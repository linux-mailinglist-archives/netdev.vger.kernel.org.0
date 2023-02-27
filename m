Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04506A4F75
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjB0XDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjB0XDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:03:51 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428AB15177;
        Mon, 27 Feb 2023 15:03:42 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso305408pjv.0;
        Mon, 27 Feb 2023 15:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U5BrsfedqjmcNewid3MjJRJMLrBkItr7J+vimPIv1pY=;
        b=V/LtQcsdtnwLA3l1X7Sdb/bUYGoRaqPEWOOnRpbxO8W0mqIJ3lp1UgHXkxS9fbVw5i
         j7aVefIdFw/NOAFs8Xp3RwleoABcucy2UaxE2tV5lYAZ2t7336Xbpe4yGYKtbVgIr7dp
         Dc2c5Ca7J0BJF5c6VwAJVG/PWen77oiV9IONT+qggSUwAon9zNKvApMJxlJDa1pkAV3q
         8fOAnaqQGGq1Culmq7DkKUF0ziTmDxko7bhsXj0jXUzwGU98pSiR65easXpMeeF8iQwS
         wAYY3E6Uox3dZ5fCPxzjrDT32kmSoCWqFb43niD0ith/h6C6bcFGXWglm2uMQerCAdIn
         7zIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5BrsfedqjmcNewid3MjJRJMLrBkItr7J+vimPIv1pY=;
        b=HM7wVjNLvLLQjwirObHUbRfxGLORMRNRt6D8fWs4GLzC9VC1ARspj4xDaflcTQmkme
         /BzvwJs72F7PkNfwVuJVsIEqKa51OMgzb6b4sZkbVIponUW+QDp2k62dd126LO8tXBqn
         k/5ZBGkJ/C3YED0s/riiZdlylNwJh7CP/QRQ/YBrIrHKCHiUUX7m6vfrtagRakhtplHp
         vFtTHShivqD5gbdn53k7QzaZUeGZDYddFAj3M14Ef4B2RREDQRvKYbkfCLxOyJiZSlnS
         2gShFbreHKP/Akuwn3v6C+EsmsA4cLYWBA2KkmQq1APTQumBXGT39enakaQIFWhzwXNY
         vptQ==
X-Gm-Message-State: AO0yUKVAqHwqPUIYm9p8LFn8CoO2w9HJm7Vq6Dh4bwS0F7nYAZtuw7xE
        70ENL+GLviePOzLGf9ZCa1dZ71qEZkI=
X-Google-Smtp-Source: AK7set/YQVhyFkanAp+++PRcsHvqrcIDF3t+kktsniJCQQU91v5eweHfCGPjixWj04TDVueYehbweg==
X-Received: by 2002:a17:902:e741:b0:19c:f1f7:681f with SMTP id p1-20020a170902e74100b0019cf1f7681fmr787393plf.9.1677539021449;
        Mon, 27 Feb 2023 15:03:41 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:6245])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b0019896d29197sm5082714pld.46.2023.02.27.15.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 15:03:40 -0800 (PST)
Date:   Mon, 27 Feb 2023 15:03:38 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets
 in BPF
Message-ID: <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1677526810.git.dxu@dxuuu.xyz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 12:51:02PM -0700, Daniel Xu wrote:
> === Context ===
> 
> In the context of a middlebox, fragmented packets are tricky to handle.
> The full 5-tuple of a packet is often only available in the first
> fragment which makes enforcing consistent policy difficult. There are
> really only two stateless options, neither of which are very nice:
> 
> 1. Enforce policy on first fragment and accept all subsequent fragments.
>    This works but may let in certain attacks or allow data exfiltration.
> 
> 2. Enforce policy on first fragment and drop all subsequent fragments.
>    This does not really work b/c some protocols may rely on
>    fragmentation. For example, DNS may rely on oversized UDP packets for
>    large responses.
> 
> So stateful tracking is the only sane option. RFC 8900 [0] calls this
> out as well in section 6.3:
> 
>     Middleboxes [...] should process IP fragments in a manner that is
>     consistent with [RFC0791] and [RFC8200]. In many cases, middleboxes
>     must maintain state in order to achieve this goal.
> 
> === BPF related bits ===
> 
> However, when policy is enforced through BPF, the prog is run before the
> kernel reassembles fragmented packets. This leaves BPF developers in a
> awkward place: implement reassembly (possibly poorly) or use a stateless
> method as described above.
> 
> Fortunately, the kernel has robust support for fragmented IP packets.
> This patchset wraps the existing defragmentation facilities in kfuncs so
> that BPF progs running on middleboxes can reassemble fragmented packets
> before applying policy.
> 
> === Patchset details ===
> 
> This patchset is (hopefully) relatively straightforward from BPF perspective.
> One thing I'd like to call out is the skb_copy()ing of the prog skb. I
> did this to maintain the invariant that the ctx remains valid after prog
> has run. This is relevant b/c ip_defrag() and ip_check_defrag() may
> consume the skb if the skb is a fragment.

Instead of doing all that with extra skb copy can you hook bpf prog after
the networking stack already handled ip defrag?
What kind of middle box are you doing? Why does it have to run at TC layer?
