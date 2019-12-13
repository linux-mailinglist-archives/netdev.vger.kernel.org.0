Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF4411E619
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfLMPEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:04:14 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46363 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLMPEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:04:14 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so1690077pgb.13;
        Fri, 13 Dec 2019 07:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=57vMBlnpciL/juUhZmhXykw/E2smdFCzEpCa1v5KKHs=;
        b=fhH1d+8EovXL8gJtcHHnZLRLckuWRxEcfJQEeZ2PV0j44r6FVxxa3jZMlyeTu/GmOF
         X54VXv6FZwzh87RugImVHB8DZK/pHqeJ9jThLb3vsLlAg7gFjUMQURPSCI/aoISI0hDp
         W03Z+c6SMuB9FN+t4Xu9u8W5kta1Azl0XTXCuFimNSqijnmh4TLI1FpwUrKq38yu48ol
         eE0dMC0wyhk0NogKufKz72HJ49xK44DhieWhdwWQA/S88b8U0XmsqgEDBaG6ap4guZqy
         g687i+QAx/QIbgbxBABNCrz6/wYASfzbq5OgrIUt/iyopk7fcyJyrlHCRyMIpJORKUh2
         gpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=57vMBlnpciL/juUhZmhXykw/E2smdFCzEpCa1v5KKHs=;
        b=KfjGXFQXngIyeB9k7vo/lH8p944pHyn3TTXIfM9I3zU6oy3anuIu67tNboXBSAPNuZ
         x4FQ+NBWrumVVF8ailXUIONOFFI4Pm6A7iuB81UCVv9CRp0cy1MhBKTB1WiEj9SpRBof
         FvGhUecHYXifriaHmLx2kV2BwJvt/1Q13uHzcAzPYYVEW9tGVBPcAmiNJhSndM6bMKC+
         dEC37ufIg5XfkwyUf5LULp8F+Y1g0VTXJIrXfyOzo9mTS0RIb1uVyM7+y/HXxvcLdr90
         920lBxXLhIhFUv8ssGAheLyTejJnm0sBnhYacozxA5Gh60ErUJJ5ys3/gcP9b3iTGJC+
         YhpQ==
X-Gm-Message-State: APjAAAXIsfxM/ONUNP75WeZ+8s9Kj+xSkWGiPrajQY0FPd0UWz12XoQS
        7AVSr0cB+ZGolcdwma87RXM=
X-Google-Smtp-Source: APXvYqyyw4vy9CkJAbKOoeQMxtp42hxEN29HXtnd6y4ks1cvb69JSf9oCtPXbbe8T5/BZsBN73ICVw==
X-Received: by 2002:a62:5202:: with SMTP id g2mr16319864pfb.43.1576249453273;
        Fri, 13 Dec 2019 07:04:13 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::4b46])
        by smtp.gmail.com with ESMTPSA id e188sm12209505pfe.113.2019.12.13.07.04.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 07:04:12 -0800 (PST)
Date:   Fri, 13 Dec 2019 07:04:09 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= 
        <thoiland@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
 <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp>
 <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 08:51:47AM +0100, Björn Töpel wrote:
> 
> > I hope my guess that compiler didn't inline it is correct. Then extra noinline
> > will not hurt and that's the only thing needed to avoid the issue.
> >
> 
> I'd say it's broken not marking it as noinline, and I was lucky. It
> would break if other BPF entrypoints that are being called from
> filter.o would appear. I'll wait for more comments, and respin a v5
> after the weekend.

Also noticed that EXPORT_SYMBOL for dispatch function is not necessary atm.
Please drop it. It can be added later when need arises.

With that please respin right away. No need to wait till Monday.
My general approach on accepting patches is "perfect is the enemy of the good".
It's better to land patches sooner if architecture and api looks good.
Details and minor bugs can be worked out step by step.

