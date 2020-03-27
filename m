Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3230E194F9E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0DRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:17:36 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:46896 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:17:36 -0400
Received: by mail-qv1-f66.google.com with SMTP id m2so4245168qvu.13
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 20:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a8Gu+EpIde/+svN1ynyCE+UfoDhiXovTJfTePco7PcU=;
        b=c2psTOZvU1g1lUfG8AqqjdVpzveR1f9tqbCuEvm5HDxIDZADMFuIRZozMYMZrCZ54/
         ib5T3/Id9ZUqQ7WP2k5h4Ys9qK7XsszIu/QcyedYHnGHUluQIxfXww79fGvuSs/FOJp5
         r8QA/WW0CsFZAHlDrS03b6wF4FqoUwfQ7QqvnZm9JAgqSslF6/i8VR/7iHdKd5SfAxPs
         mEU9DOPzYX2Xcb7cwj3QYb/GpUAiFpTQgpPnmvS62F/RWW5QWDhXO1UaulGuFd3bf+TQ
         3R3GxVIbkgk6gNt9B64s1n9Kse4QTux8alR9R++sRSr3eQIHqaYwSDllyOyfZ+fyYe20
         PDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a8Gu+EpIde/+svN1ynyCE+UfoDhiXovTJfTePco7PcU=;
        b=T1QJaL8SZJL9v3ZqRMH1LdIHoocDNkhjkUBd83fFnBzialRqPBsRcia6mvvQQYbOcT
         XyK1W94jbRU0S3ABVbNhq2tQmrnnpGcuu+7OXPUWeQ2URnTGYlLy5/ql6/TK4ULrrYj6
         9qbeHkSYLJo4J43XDFekJ2A0+fENNSdPLCUf/yCpWcVtmR1FB8KM+BI2RwJMQQJdIKoJ
         +nclq/8taDIiHwYZjnoPZPZ2fLABboNqPzG/R5RA5gqCSu+n9rs/rqE5g2nZ5LQbD8Tc
         hXjvpUrdkZyRKSAtkJBWbbwO7ZK0tRJEYCVlijbshpnbJlFoGuLb4FVmXm6XSdHerXCI
         Eq7g==
X-Gm-Message-State: ANhLgQ3EkDv/ejuGRMGZDK6xMYSR/OEp5nQ8QEgJPxTXcuYYflplJJHN
        CGDT+b2Zug/KjLP5gtdS4MEU1Z3+
X-Google-Smtp-Source: ADFU+vtD21pus/kgpvklq83LTdd5fYPO+tvMHdnGlE62E/S7QQ6Dq2/qzXEDtRFukJUO7weaX4OiCQ==
X-Received: by 2002:ad4:4766:: with SMTP id d6mr11014432qvx.136.1585279055334;
        Thu, 26 Mar 2020 20:17:35 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id t140sm2798190qke.48.2020.03.26.20.17.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 20:17:34 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id r16so3784282ybs.13
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 20:17:34 -0700 (PDT)
X-Received: by 2002:a25:5057:: with SMTP id e84mr2144221ybb.441.1585279053731;
 Thu, 26 Mar 2020 20:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com> <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com>
In-Reply-To: <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 26 Mar 2020 23:16:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
Message-ID: <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFt2Z2VyLmtlcm5lbC5vcmfku6Plj5FdUmU6IFt2Z2VyLmtlcm5lbC5vcmfku6M=?=
        =?UTF-8?B?5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0OiBmaXggVFBBQ0tFVF9WMyBwZXJmb3Jt?=
        =?UTF-8?B?YW5jZSBpc3N1ZSBpbiBjYXNlIG9mIFRTTw==?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Mar 25, 2020 at 8:45 PM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
> >
> > By the way, even if we used hrtimer, it can't ensure so high performanc=
e improvement, the reason is every frame has different size, you can't know=
 how many microseconds one frame will be available, early timer firing will=
 be an unnecessary waste, late timer firing will reduce performance, so I s=
till think the way this patch used is best so far.
> >
>
> The key differentiating feature of TPACKET_V3 is the use of blocks to eff=
iciently pack packets and amortize wake ups.
>
> If you want immediate notification for every packet, why not just use TPA=
CKET_V2?
>
> For non-TSO packet, TPACKET_V3 is much better than TPACKET_V2, but for TS=
O packet, it is bad, we prefer to use TPACKET_V3 for better performance.

At high rate, blocks are retired and userspace is notified as soon as
a packet arrives that does not fit and requires dispatching a new
block. As such, max throughput is not timer dependent. The timer
exists to bound notification latency when packet arrival rate is slow.
