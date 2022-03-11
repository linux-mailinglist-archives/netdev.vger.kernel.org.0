Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B874D636F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349299AbiCKO3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiCKO3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:29:03 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3EA1E3DA
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:27:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so7595879wmj.2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MpXiSYabOrYwVZBoUNg0nqtYEvuBi16Uja5dFf2EH0o=;
        b=k2nh2gjDZ2GWduILDMTVTdPhwUGy/gKiaKiDAAeWeNvWs+qTTrNrgWKCpvV5YZTUem
         oS/VqO60ezzCYtbnUQI49E+RYcTTpPSClCwilaRKFbUWSxsD5nb47zN5aSspNsfFktFZ
         FkbA1p2tgEoHpfs74AHjwcd7z1Fmq06KPg4uI1LJjNZjy+w0+El9JAo7Kd2WQgnuoWT+
         HpMizIPvpJ4kBD8vcbDXLo7JWtSiBBROSlbVgdGvOfUJcbc+q2t6xbeJDOeNJ7IgcDkf
         oPtG5W7BIAAQOD9tgIZbFNVeFcpnIzkbhUQGtMeyPsJMSxGYr8R3kg3jnU3j/sB/SxSq
         Xk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MpXiSYabOrYwVZBoUNg0nqtYEvuBi16Uja5dFf2EH0o=;
        b=hIfFpnqIjOYM77GgCaaLLfU0sOznYUhVCIm1CpfYakEAy6Xtul50yR124t7K9PVgTY
         AOMZx30NNfAVQxtdxYR9UDUrubL7IMV1IZ8D7I/EBCzVyNKJdxUaXuu/v5ikrMCpUz/q
         wUFZZdcewVoEpN6nZEaTKNM4HWspmiJ3a50AngHIjMErQZkoaZJAn1JcN6Lk2HHax/ol
         k35rtleyztqztVpihyxdgFi9jYIyEizBc9Hr9MBJ5cySIDOrBJ6h0wpAMfR8dXaguVd9
         lcQ+chDfo0gmQjBpdseWxbg+m4p+hgKsmQdSsPFC4/Z8lx2u4eroN5xfJ1PC94GB2FX9
         oqdA==
X-Gm-Message-State: AOAM530Gi09Nl+Wr12hbOWrJVjX4jAAVywZeZCPcy7DCat4xS77sn3uv
        ELCIkQ8diAo8N21TE/tpQJgI6g==
X-Google-Smtp-Source: ABdhPJxQojmr11qBMELiUdbxhAZwsibac1eN9niCtFM0AGC0j84YVyfws1DV7ZJcT9GegkvTIMpT+w==
X-Received: by 2002:a1c:f718:0:b0:380:ed20:6557 with SMTP id v24-20020a1cf718000000b00380ed206557mr16407510wmh.53.1647008876745;
        Fri, 11 Mar 2022 06:27:56 -0800 (PST)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id u23-20020a7bcb17000000b0037bdfa1665asm14118274wmj.18.2022.03.11.06.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 06:27:56 -0800 (PST)
Date:   Fri, 11 Mar 2022 14:27:54 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
Message-ID: <20220311142754.a3jnnjqxpok75qgp@maple.lan>
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com>
 <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
 <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 04:35:36PM -0800, Linus Torvalds wrote:
> On Sat, Mar 5, 2022 at 1:09 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> What do people think? Is this clever and useful, or just too
> subtle and odd to exist?

> NOTE! I decided to add that "name of the target head in the target
> type" to the list_traversal_head() macro, but it's not actually used
> as is. It's more of a wishful "maybe we could add some sanity checking
> of the target list entries later".
> 
> Comments?

It is possible simply to use spelling to help uncover errors in
list_traverse()?

Something like:

#define list_traversal_head(type, name, target_member) \
	union { \
		struct list_head name; \
		type *name##_traversal_mismatch_##target_member; \
	}

And:

#define list_traverse(pos, head, member) \
	for (typeof(*head##_traversal_mismatch_##member) pos = list_first_entry(head, typeof(*pos), member); \
		!list_entry_is_head(pos, head, member);	\
		pos = list_next_entry(pos, member))

If I deliberately insert an error into your modified exit.c then the
resulting errors even make helpful suggestions about what you did
wrong:

kernel/exit.c:412:32: error: ‘struct task_struct’ has no member named
‘children_traversal_mismatch_children’; did you mean
‘children_traversal_mismatch_sibling’?

The suggestions are not always as good as the above
(children_traversal_mismatch_ptrace_entry suggests
ptraced_traversal_mismatch_ptrace_entry) but, nevertheless, it does
 appears to be robust in detecting incorrect traversal.


> diff --git a/include/linux/list.h b/include/linux/list.h
> index dd6c2041d09c..1e8b3e495b51 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -25,6 +25,9 @@
>  #define LIST_HEAD(name) \
>  	struct list_head name = LIST_HEAD_INIT(name)

Seeing this in the diff did set me thinking about static/global
list heads.

For architectures without HAVE_LD_DEAD_CODE_DATA_ELIMINATION then the
"obvious" extension of list_traversal_head() ends up occupying bss
space. Even replacing the pointer with a zero length array is still
provoking gcc-11 (arm64) to allocate a byte from bss (often with a lot
of padding added).

Perhaps in the grand scheme of things this doesn't matter. Across the
whole tree and all architecture I see only ~1200 instances so even in
the worst case and with padding everywhere the wasted RAM is only a few
kb.

Nevertheless I was curious if there is any cunning tricks to avoid
this? Naturally LIST_HEAD() could just declare a union but that would
require all sites of use to be updated simultaneously and I rather
like the way list_traverse_head() is entirely incremental.


Daniel.
