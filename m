Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C008251049
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHYECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgHYECQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:02:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65740C061574;
        Mon, 24 Aug 2020 21:02:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k18so6265517pfp.7;
        Mon, 24 Aug 2020 21:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWP3Doavv4AA5MTHUfERK+5fDLCAAOxRkHFkQDFePYA=;
        b=bQ3ljGLC5BwLgsiUgJYdqoqrw82XUREWO5/zTU4ADXG0Rc4P1VD0jZc08F4Tbg+HGu
         gOU4qbbhal7hgak17fkRX/tUP8su+EV3UTQtpobsbbacR3iu5suqB7zQfpIbg2gbCwVw
         EkwiT8320NlykE/ORi7g6NrM2Kiw6b5lhohmdZi4983A/haT/GzpqNQHB/TIdTsZr8NR
         HRignxCoDEXJ4QvPyOo/3Fl9cSTNT8r6pfbksgku/jYXMRuXKz0Q0am9eGEgJOf5Rxhf
         Y5BNxAkVsZv3WwCoXT/EH+JZWiizLF9BjipG/NDDZLyF18QJcO7u7irhHqOeq9JkjxB4
         dHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OWP3Doavv4AA5MTHUfERK+5fDLCAAOxRkHFkQDFePYA=;
        b=uT4yBDtIXxDKYV1wGheg8BY3AHt46yNShldVqNgwkjPfO3Tx4iTv9Hq0BbCtWbmgd/
         IU3wUaJ8+44tZM3RfQDXfbAx4rZM6L1uA0Z47EULzY+iFrEWGc45FR7jTaAFRXwyce6t
         FFhcmQB/gCBl/HtnVJdM66sWS9f4qLqICjnOGO1hQAXVsrtP3OxcMfyT5WeBU0aT4D2a
         s1EZhxc3/eriaNMMndkIIVdEIQFjFrgBD2efSYMe8H7eXCiWLXID9Z40vpnzvN5Tv5E6
         F+cMqMgUnLJzgv6oyhBwGg/1bdcNxna+R9zZhmeW2NyGRX6Wh6waGBtffdVph3IFZ+3i
         bkvQ==
X-Gm-Message-State: AOAM530sh2HbWVAZej67kJ6U4YSpsYSweLeT7mLFt3DTGF/BC9K7J19+
        egss4GGJ85KJMr2eiXDrvcg=
X-Google-Smtp-Source: ABdhPJzZSXK3qRkITFj5doK44JXAAp3hdl6VDwNzNrQomSSXun/dR/mHs4ls7u4rsaqFWOa8UNcj6Q==
X-Received: by 2002:a63:e301:: with SMTP id f1mr5434785pgh.169.1598328134975;
        Mon, 24 Aug 2020 21:02:14 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1561])
        by smtp.gmail.com with ESMTPSA id v134sm7781620pfc.101.2020.08.24.21.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 21:02:13 -0700 (PDT)
Date:   Mon, 24 Aug 2020 21:02:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/3] samples: bpf: Refactor tracing programs
 with libbpf
Message-ID: <20200825040211.zoo3s4wf2gi23f3t@ast-mbp.dhcp.thefacebook.com>
References: <20200823085334.9413-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823085334.9413-1-danieltimlee@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 05:53:31PM +0900, Daniel T. Lee wrote:
> For the problem of increasing fragmentation of the bpf loader programs,
> instead of using bpf_loader.o, which is used in samples/bpf, this
> patch refactors the existing kprobe, tracepoint tracing programs with 
> libbbpf bpf loader.

Thank for you doing the conversion. Applied.
