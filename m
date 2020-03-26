Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CD0194112
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgCZOQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:16:32 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40868 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbgCZOQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:16:31 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so4946981lfe.7;
        Thu, 26 Mar 2020 07:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qXdFHUWSCp669/WHwL4HbHxImLf08oY2s3iOgsN6H0=;
        b=dUX0IAtZBxJ+J3DAZGtKGnr5Mgq0bTaOPZfgbAtlYlpl+UFE2jkKA7nKcto9JJf4KT
         bwuDGClW12swbjLwDr/4hmqHm8KSiQbgWtJsec+kNoECp3DgRXFm5I20Ln0CY+9lkxgW
         0toc7oks9qn6p69udG1EmGDxSamOZLTmvcdIVmrZZzd/nTFhYq8JbR/Ac1WalZZy2rAP
         B8F9et2wKpvoQKSSaPoorGsaC7ApcB2q8t+sj7H7FvHoGfOxZG91FYuYO0YtWn2i5j65
         R6Ipusj6GoVo/PyX9u1dQAlJhmA/7HJYQ6NZj3cGYfAs1WnKPTvri6M59K1LyNw4wU4S
         lFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qXdFHUWSCp669/WHwL4HbHxImLf08oY2s3iOgsN6H0=;
        b=SoTkmnKPPFPM4vqPaOrfA0ZEcrSzcqr6SBitrbFRb0Wk8vOgSNBe7TlFQTZtfYIZWW
         QGhCiORUjmz6mVKYhoRV4YaCnCxvi/ahk32JWO21sSFj5WMJvTgHoryh9AvO2cIQWa7J
         JAuhr8n7kiyiALZPnirpyWiP+Bu6/Iz7QlQt9PD4Fy1bGameH+diNyGQB8RTLbPy+pU8
         ACll3kyzynYFDiKeBtdSZt6o6twltuaYbkJ6bM985Y1iW09W2rqT4HHPt8cLrna7Jlaj
         9n3RoI4ZkKVm6a1HY17wg8osjl8LMU/cLQpqTN7u33N7k08rG9yAyE8cdWTspR8rqPEL
         Ss7Q==
X-Gm-Message-State: AGi0PuauthnTTALgUG3amdLNAxyUtTXvHNvcKrDiBRbvMElk119Ueos9
        84oevVPaNuICCO57aFmhSQercgNeOrcQh2kPOiI=
X-Google-Smtp-Source: APiQypLyOxIsk9spzm+cIk2VhOAZWI5yynOlWw7ymhbBCElhxdaAqM2EyoMnmg66pbjkoDxjAWjVFzh8MtFIE9XxFY8=
X-Received: by 2002:ac2:5f52:: with SMTP id 18mr1373825lfz.133.1585232187089;
 Thu, 26 Mar 2020 07:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200320030015.195806-1-zenczykowski@gmail.com>
 <20200326135959.tqy5i4qkxwcqgp5y@salvia> <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
 <CAHo-OozGK7ANfFDBnLv2tZVuhXUw1sCCRVTBc0YT7LvYVXH_ZQ@mail.gmail.com>
In-Reply-To: <CAHo-OozGK7ANfFDBnLv2tZVuhXUw1sCCRVTBc0YT7LvYVXH_ZQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 26 Mar 2020 07:16:16 -0700
Message-ID: <CAHo-Oow8otp4ruAUpvGYjXN_f3dsbprg_DKOGG6HNhe_Z8X8Vg@mail.gmail.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I guess maybe we could wrap it in a

#ifdef BPF_F_RDONLY
attr.file_flags = BPF_F_RDONLY;
#endif

if we want to continue supporting building against pre-4.15 kernel headers...
