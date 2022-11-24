Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD62E636FB7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKXBSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiKXBSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:18:45 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E38106102
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 17:18:43 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id l190so215828vsc.10
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 17:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7tBUw05aOdjyO9WsFCtTrKc5G8bk3/uCIv/FSXOVjTg=;
        b=cR5Tx2OzMDMnzLuq7r4ycWlRO2gzxpltG7WVxggQ3gkD+H3QiCLqshLPiuVxRJBFSU
         0Dsod0ESCG9U1Y2Aqi9PF/Nv0lOtf83kNL85Mf0frsQ6U3JQ76FniUpqF2VAjwvca1/R
         WUvPfq1mJ0L6Y7QVHxD4+iO9ze85KXFCSaLauEtk3/gSVWHeaP7bEmE8bzDOwW68Pm/7
         8kYPeF3UpkDZOn5PVa5upr+5tIqawN9l5Kge+KTEeHp8MWMmzNnu+YgckbCx/b91yURh
         sdLhWAYMIsjgOSUVC4+ufPavt+Btcq6W8cnHS2pv41s+tlftvvgZPEFPXzgj+qIQTbSC
         CdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7tBUw05aOdjyO9WsFCtTrKc5G8bk3/uCIv/FSXOVjTg=;
        b=S3WkDwt3ZmcD34lNTEXo8G52ZA1U16Sao0+6brT40DcFnvXB+/oNq/+2H66E4p2onV
         7Kh0/DVnz3CewYeeejiW88YhCoifrzEV65MYU6q2BCovgKNG9WAdESVUpif8DgAmi5kv
         aDpNYEmOCzoudQhpHOAF6vGbinC/DUdmcXKjzkL7shWa+6WCERHLk5oyFtd5TyAu/IWi
         +qJREtVuXgT+NTnVaKwNE2x5W3zcsK8meaUCi8WRjGdVcCAcmd8Twx5fMrNLBykjriTx
         DUe0RwbpwTFwyNAAsXbkx4x7GxNAge+Yn88u0VepuYXrpokz+oQRnmeBp4SNQvMpQfpR
         E68Q==
X-Gm-Message-State: ANoB5pnQvOZtaC32dCMObYc416o8i2+aZO2asagJWd9K4HKFqxzO7lFw
        5VmEa1UUYFUyLg1pKEVN6ZQBlbkWl0uaNN5NA0aT1g==
X-Google-Smtp-Source: AA0mqf7tE/DJhqO/TmFy0k5UO6O+PUJ9K2GXNEe37t1kmvS+5u/3QWe/TPoislPxXNK6S3D8kkMtK+Q3OHAWXbFToEs=
X-Received: by 2002:a67:c98e:0:b0:3ad:3d65:22b with SMTP id
 y14-20020a67c98e000000b003ad3d65022bmr7748848vsk.65.1669252722617; Wed, 23
 Nov 2022 17:18:42 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
 <Y31s/K8T85jh05wH@google.com> <Y36PF972kOK3ADvx@cmpxchg.org>
In-Reply-To: <Y36PF972kOK3ADvx@cmpxchg.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Wed, 23 Nov 2022 18:18:06 -0700
Message-ID: <CAOUHufZxguv_m3Td7e5Qt-yKpV7rmWyv_m_UFS9n19K=_=xLcA@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 2:22 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Tue, Nov 22, 2022 at 05:44:44PM -0700, Yu Zhao wrote:
> > Hi Johannes,
> >
> > Do you think it makes sense to have the below for both the baseline and
> > MGLRU or it's some behavior change that the baseline doesn't want to
> > risk?
>
> It looks good to me. Besides the new FMODE_NOREUSE, it's also a nice
> cleanup on the rmap side!
>
> It would just be good to keep the comment from folio_referenced_one() and
> move it to the vma_has_locality() check in invalid_folio_referenced_vma().
>
> Otherwise,
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks.

I've added Ivan's test case to my collection. Interestingly, after
this patch, the download speed increased while fio was running (my
guess is that fio pushed more cold anon into swap):

$ uname
Linux test127 6.1.0-rc6-dirty #2 SMP PREEMPT_DYNAMIC Wed Nov 23
16:51:20 MST 2022 x86_64 x86_64 x86_64 GNU/Linux

$ go version
go version go1.18.1 linux/amd64

$ fio -v
fio-3.28

$ curl --version
curl 7.81.0 (x86_64-pc-linux-gnu) libcurl/7.81.0 OpenSSL/3.0.2
zlib/1.2.11 brotli/1.0.9 zstd/1.4.8 libidn2/2.3.2 libpsl/0.21.0
(+libidn2/2.3.2) libssh/0.9.6/openssl/zlib nghttp2/1.43.0 librtmp/2.3
OpenLDAP/2.5.13
Release-Date: 2022-01-05
Protocols: dict file ftp ftps gopher gophers http https imap imaps
ldap ldaps mqtt pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps
telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN
IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP
UnixSockets zstd

fio NOT running:

 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  83.6M      0 --:--:--  0:00:57 --:--:-- 87.0M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 79.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.7M      0 --:--:--  0:00:57 --:--:-- 89.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  87.4M      0 --:--:--  0:00:54 --:--:-- 94.3M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.1M      0 --:--:--  0:00:54 --:--:-- 94.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.6M      0 --:--:--  0:00:57 --:--:-- 83.9M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.4M      0 --:--:--  0:00:55 --:--:-- 90.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  82.8M      0 --:--:--  0:00:57 --:--:-- 67.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  83.4M      0 --:--:--  0:00:57 --:--:-- 78.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  84.0M      0 --:--:--  0:00:56 --:--:-- 87.4M


fio running:

 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.7M      0 --:--:--  0:01:11 --:--:-- 88.7M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  87.7M      0 --:--:--  0:00:54 --:--:-- 93.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.5M      0 --:--:--  0:00:53 --:--:-- 95.1M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  91.6M      0 --:--:--  0:00:52 --:--:-- 94.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  89.4M      0 --:--:--  0:00:53 --:--:-- 86.6M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  88.6M      0 --:--:--  0:00:53 --:--:-- 84.8M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  84.6M      0 --:--:--  0:00:56 --:--:-- 87.5M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  86.9M      0 --:--:--  0:00:54 --:--:-- 81.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  89.0M      0 --:--:--  0:00:53 --:--:-- 86.4M
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4768M    0 4768M    0     0  91.1M      0 --:--:--  0:00:52 --:--:-- 90.6M
