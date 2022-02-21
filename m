Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599304BE405
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiBURDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:03:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiBURDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:03:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8603725EA2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:02:42 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f8so14786240pgc.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=jdo6qs3W3VWxl2VOEPHnxDm9DO0+mjPtSUqp/JaJSO8=;
        b=3LF8PPUHqEonUEH3rkDuj8pEfMX0ycLuC7NndFyBgl4rBHATg+5BOxQaHQUvFRS6vN
         nD5/bXyLNZzHdOfkgN7expaEv/qy++JR4gtkny9aESJSIwzSUMvuJmnbno4sSzi42FqH
         b2lLVcyydPQzgwssytnNqTu7ldDWr5RKIaURbHu8bAeYEpcuoP2BPYjqoQeuifn52jz8
         PlR9pIjpCPbyAco5MDYw9waVKOLu4tI/HkmzVxQzuAVPpDe8a3Ip1NC6KitaJ9fZcPYF
         vZpgHwya6nZp+AD4twpCk4pAANx9uIsrd/iG7vKGsdK0qM3d/bB6anXBIlvnsYqAZ/mg
         VwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=jdo6qs3W3VWxl2VOEPHnxDm9DO0+mjPtSUqp/JaJSO8=;
        b=hXR3dt3nXzkzw5bbAxKkvb4RXwmCH7V0O+dqFs6AB13QMLo8r0ajBUMD58wi0frkzr
         4Hl73gW4921aB6ivz9rUjckaUl7pmmvMHCXwNl4p8Da55cJH7LkmcbPGLcMmgzq6b4ku
         iGCTrSnZDMNtnnvevZ+7+gdAqvzy+PycgS+6y85oLLoMdkvIcX8tQzGVd/PODQAUPsAB
         VKfAfDUECNv3HlZACVQ5MU1JssikaUb1Bzqk47jeUP2gZw3jECfI6uKgPE0RWMWwkZxi
         WB7wDh696GN5ytb+pO5GduMDMmA3EZHKXnQ5pxgjxEZUr1d7UNI4IjOA0jVZNfKtMgQA
         Kspw==
X-Gm-Message-State: AOAM531mMGLzajuCLVaZTFJOqkHfOmRIj/NlKrTibGD8jRg+cvicWu9t
        MSmdKHjh1xtEzPJXYw6YyWBqvrt2tYPAN+TL
X-Google-Smtp-Source: ABdhPJwAa9VIIAFoZFgPVG0RrJBi/woKEiACFQSBpBaWXnw5Kd7hQTIZQn7bqv/+1MdT96qeynhU/A==
X-Received: by 2002:a63:554a:0:b0:370:62f0:8880 with SMTP id f10-20020a63554a000000b0037062f08880mr16997979pgm.319.1645462961995;
        Mon, 21 Feb 2022 09:02:41 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id v20-20020a17090a899400b001bc44cd08fesm3067681pjn.20.2022.02.21.09.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 09:02:41 -0800 (PST)
Date:   Mon, 21 Feb 2022 09:02:38 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     yoshfuji@linux-ipv6.org, davem@davemloft.net, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 215629] New: heap overflow in net/ipv6/esp6.c
Message-ID: <20220221090238.495e8e78@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 21 Feb 2022 16:52:26 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215629] New: heap overflow in net/ipv6/esp6.c


https://bugzilla.kernel.org/show_bug.cgi?id=215629

            Bug ID: 215629
           Summary: heap overflow in net/ipv6/esp6.c
           Product: Networking
           Version: 2.5
    Kernel Version: 5.17
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: slipper.alive@gmail.com
        Regression: No

I found a heap out-of-bound write vulnerability in net/ipv6/esp6.c by reviewing
a syzkaller bug report
(https://syzkaller.appspot.com/bug?id=57375340ab81a369df5da5eb16cfcd4aef9dfb9d).
This bug could lead to privilege escalation.


The bug is caused by the incorrect use of `skb_page_frag_refill`
(https://github.com/torvalds/linux/blob/v5.17-rc3/net/core/sock.c#L2700). 

/**
 * skb_page_frag_refill - check that a page_frag contains enough room
 * @sz: minimum size of the fragment we want to get
 * @pfrag: pointer to page_frag
 * @gfp: priority for memory allocation
 *
 * Note: While this allocator tries to use high order pages, there is
 * no guarantee that allocations succeed. Therefore, @sz MUST be
 * less or equal than PAGE_SIZE.
 */
bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
{
        if (pfrag->page) {
                if (page_ref_count(pfrag->page) == 1) {
                        pfrag->offset = 0;
                        return true;
                }
                if (pfrag->offset + sz <= pfrag->size)
                        return true;
                put_page(pfrag->page);
        }

        pfrag->offset = 0;
        if (SKB_FRAG_PAGE_ORDER &&
            !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
                /* Avoid direct reclaim but allow kswapd to wake */
                pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
                                          __GFP_COMP | __GFP_NOWARN |
                                          __GFP_NORETRY,
                                          SKB_FRAG_PAGE_ORDER);
                if (likely(pfrag->page)) {
                        pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
                        return true;
                }
        }
        pfrag->page = alloc_page(gfp);
        if (likely(pfrag->page)) {
                pfrag->size = PAGE_SIZE;
                return true;
        }
        return false;
}
EXPORT_SYMBOL(skb_page_frag_refill);


In the comment it says the `sz` parameter must be less than PAGE_SIZE, but it
is not enforced in the vulnerable code
https://github.com/torvalds/linux/blob/v5.17-rc3/net/ipv6/esp6.c#L512 


int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
*esp)
{
...
                        allocsize = ALIGN(tailen, L1_CACHE_BYTES);

                        spin_lock_bh(&x->lock);

                        if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
GFP_ATOMIC))) {
                                spin_unlock_bh(&x->lock);
                                goto cow;
                        }
...

and https://github.com/torvalds/linux/blob/v5.17-rc3/net/ipv6/esp6.c#L623

int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
*esp)
{
...
        if (!esp->inplace) {
                int allocsize;
                struct page_frag *pfrag = &x->xfrag;

                allocsize = ALIGN(skb->data_len, L1_CACHE_BYTES);

                spin_lock_bh(&x->lock);
                if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
GFP_ATOMIC))) {
                        spin_unlock_bh(&x->lock);
                        goto error_free;
                }


The `allocsize` here can be manipulated by the `tfcpad` of the `xfrm_state`. 


static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
{
        int alen;
        int blksize;
        struct ip_esp_hdr *esph;
        struct crypto_aead *aead;
        struct esp_info esp;

        esp.inplace = true;

        esp.proto = *skb_mac_header(skb);
        *skb_mac_header(skb) = IPPROTO_ESP;

        /* skb is pure payload to encrypt */

        aead = x->data;
        alen = crypto_aead_authsize(aead);

        esp.tfclen = 0;
        if (x->tfcpad) {
                struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
                u32 padto;

                padto = min(x->tfcpad, __xfrm_state_mtu(x,
dst->child_mtu_cached));
                if (skb->len < padto)
                        esp.tfclen = padto - skb->len;
        }
        blksize = ALIGN(crypto_aead_blocksize(aead), 4);
        esp.clen = ALIGN(skb->len + 2 + esp.tfclen, blksize);
        esp.plen = esp.clen - skb->len - esp.tfclen;
        esp.tailen = esp.tfclen + esp.plen + alen;



If it is set to a value greater than 0x8000, the page next to the allocated
page frag will be overwritten by the padding message.


The bug requires CAP_NET_ADMIN to be triggered. It seems to be introduced by
commit 03e2a30f6a27e2f3e5283b777f6ddd146b38c738. The same bug exists in the
ipv4 code net/ipv4/esp4.c introduced by commit
cac2661c53f35cbe651bef9b07026a5a05ab8ce0.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
