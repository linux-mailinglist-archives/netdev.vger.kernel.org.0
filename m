Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77A962EC19
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiKRCth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiKRCtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:49:36 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5680619001
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:49:35 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t17so2649200pjo.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 18:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2MLtAkRfbJhZf5rMnPSno/F7bvPA6srtiggf6Ycjeo=;
        b=FIBkgYf1C1m1EuanBWZDnu+pktLwbsU3Bvg/Us+SAgskcrKFaiIK/2YEx+4UXdre8m
         uiiNhoLXZZtkLiaMS4ULVHYK/fr79sn3CeSeP/rQIBGitJkuRLi/IIZojXA1lud9Jtht
         PnR4XIriwJhNvXst+2q6bsOnPfCaCAfc7c7t4KTx3cChXkdC0p4x+pesxrYjMpXY/2cw
         7587qZptfLL+rCWRsci2tSyno15NlyiqEqjcbORk3vPsfi/jcd3zGP4YB3RwgCQwlLa4
         z8MzSIXDcXYyLIgAGMmWytF5DP34kvSSJLig+/RJVd1OPAhUz+aGzoc+/D5XAel7cC9v
         doww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2MLtAkRfbJhZf5rMnPSno/F7bvPA6srtiggf6Ycjeo=;
        b=y8WXdjwwcyDfPTruuu1fJh/AmfU5OzhL/mfEOj2JayaFoxvDh5Mx9IygrRilG4rX5v
         Jnxt3KnIWA6pBBCAjLgqNNxWrGETKEtksKKILNu4tAMixbjBTvnsSwK6EcjSbG8hmSUa
         0XgWDf+ou7WEOWdxPqQF50nt+l8SUMu8fQlpu2RFQCL2U6I7f8M2I4GDVhyjWLMluQdF
         FFC/rWxXkl5n2ZNRMRUReNq1XkT1KSDml6VfmuwUJYJLygIBkNfkHAmiVl76GygfJXYO
         5fT9z3zDcXeTSKhFI5/ZNBjy9Y+h2egYjjSUh3xQjV7Hk6D6OPWR/EQtJ//gHQLrPSIZ
         MIVA==
X-Gm-Message-State: ANoB5pn9ImxBFWOJKByqS5qUwCpaUuTlnmgNqHV+pXwnBhbwmJKSLLp8
        lqI3rZnRjokEfVWd8bI0qZy0NNvG4LtTXw==
X-Google-Smtp-Source: AA0mqf5djNQxJUnUauXSozpjoygGzFcPjgB+fAYRyN5XylUCBi7O1koBaEy2A3DMa4Vo2YpEH3kpjA==
X-Received: by 2002:a17:90a:1a12:b0:20a:6ffc:f0c6 with SMTP id 18-20020a17090a1a1200b0020a6ffcf0c6mr11804858pjk.49.1668739774849;
        Thu, 17 Nov 2022 18:49:34 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 125-20020a620683000000b005385e2e86eesm1969399pfg.18.2022.11.17.18.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 18:49:34 -0800 (PST)
Date:   Fri, 18 Nov 2022 10:49:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y3byuXrgNA61JTDz@Laptop-X1>
References: <17540.1668026368@famine>
 <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
 <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
 <Y3SEXh0x4G7jNSi9@Laptop-X1>
 <17663.1668611774@famine>
 <Y3WgFgLlRQSaguqv@Laptop-X1>
 <22985.1668659398@famine>
 <Y3XyGIVnX2xvZ/bU@Laptop-X1>
 <24154.1668715451@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24154.1668715451@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 12:04:11PM -0800, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >On Wed, Nov 16, 2022 at 08:29:58PM -0800, Jay Vosburgh wrote:
> >> > #if IS_ENABLED(CONFIG_IPV6)
> >> >-	} else if (is_ipv6) {
> >> >+	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &ip6_hdr)) {
> >> > 		return bond_na_rcv(skb, bond, slave);
> >> > #endif
> >> > 	} else {
> >> >
> >> >What do you think?
> >> 
> >> 	I don't see how this solves the icmp6_hdr() / ipv6_hdr() problem
> >> in bond_na_rcv(); skb_header_pointer() doesn't do a pull, it just copies
> >> into the supplied struct (if necessary).
> >
> >Hmm... Maybe I didn't get what you and Eric means. If we can copy the
> >supplied buffer success, doesn't this make sure IPv6 header is in skb?
> 
> 	The header is in the skb, but it may not be in the linear part
> of the skb, i.e., the header is wholly or partially in a skb frag, not
> in the area covered by skb->data ... skb->tail.  The various *_hdr()
> macros only look in the linear area, not the frags, and don't check to
> see if the linear area contains the entire header.
> 
> 	skb_header_pointer() is smart enough to check, and if the
> requested data is entirely within the linear area, it returns a pointer
> to there; if not, it copies from the frags into the supplied struct and
> returns a pointer to that.  What it doesn't do is a pull (move data from
> a frag into the linear area), so merely calling skb_header_pointer()
> doesn't affect the layout of what's in the skb (which is the point,
> bonding uses it here to avoid changing the skb).
> 
> 	There may be better explanations out there, but
> 
> http://vger.kernel.org/~davem/skb_data.html
> 
> 	covers the basics.  Look for the references to "paged data."

Hi Jay,

Thanks a lot for your explanation. I thought you mean there may no IPv6
header in skb. Now I know the problem is using ipv6_hdr() for non-liner skb.
I will update the patch with Eric suggested.

Thanks
Hangbin
