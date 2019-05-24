Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02B28ECA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388735AbfEXB1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:27:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39331 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388645AbfEXB1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:27:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so4259604pfg.6
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EVMg6Qtj7ikChCelvTU+2YJkv4PCfrgHPBFORJX3mFA=;
        b=GaZBo4/N13xcQn4sMkr2O5w7wNgDefNiWAKdsS7AGvCIFyaNC0NzPzgxQN43sRjTao
         mu3oRTyvQFjyVjkGf1I75HDbuiUS3N2KZGuRo/07GUpV/KVTxTLDd/Eys5H8BNiLOMUU
         YsBrJYnINu4jiox+VecZg3XLXSm/9PU8Xh1TI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EVMg6Qtj7ikChCelvTU+2YJkv4PCfrgHPBFORJX3mFA=;
        b=LQ4VyU5qzKyRL4Pt5E3Aaxg8g6r6LIuAk2z8fROy0SGP4OleY0ElpN/FKb7yGDhzE3
         2zzlHzYd/641pXfXiqlnzY7EchD0JVxI1O/hErJhQqNU6dHEb8jvjIgzpSHewTnSexLv
         j8hrruTU5MDIZ0xFjC4rNtWKgaI3qzghRJxfJElXH9b0f9x6GcJfXd0RmAIWU1QR3WDr
         FXMkK+RlDpJMLVXZBzGefntGnqEhtEdbxX+3HF89XC8SJcnGuzFczGs72u+jWcbNICg8
         j/pdB/UqLz7iIag2P+GRpzt9JS/SJsF1j5nl+pfP4FP+mud51Jg5t18oOI400/runxvE
         azUg==
X-Gm-Message-State: APjAAAVhkoDra+fRMcnPfVtrd8v0xQIrzn8GMqbmod/p6oQEdNTzp661
        H0OcJCigvrO8fKnaiFq2dAlHkyWeowYCiIJe
X-Google-Smtp-Source: APXvYqyKssmrS9+A0qv02q3F8yGSQprA43jRQmjfROvEFJaqxDoRlQelfPhryzHN6zl2OxVRx0Wh3A==
X-Received: by 2002:a17:90a:e390:: with SMTP id b16mr5606709pjz.137.1558661264376;
        Thu, 23 May 2019 18:27:44 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id c14sm516923pgl.43.2019.05.23.18.27.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 18:27:43 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
Date:   Thu, 23 May 2019 18:27:41 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D68C643B-C6A4-4EC5-8E4F-368BDE03760B@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem, this is only my 2nd patch, and my last one was a one liner.
I=E2=80=99ll try to work through this, but let me know if I am doing a =
rookie
mistake (learning curve and all).


> On May 23, 2019, at 2:56 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20
> On Thu, May 23, 2019 at 5:11 PM Fred Klassen <fklassen@appneta.com> =
wrote:
>>=20
>> This enhancement adds the '-a' option, which will count all CMSG
>> messages on the error queue and print a summary report.
>>=20
>> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
>=20
> Also not a fix, but an extension.

I=E2=80=99ll make a v2 patch and remove =E2=80=9CFixes:".

>=20
>>=20
>> Example:
>>=20
>>    # ./udpgso_bench_tx -4uT -a -l5 -S 1472 -D 172.16.120.189
>>    udp tx:    492 MB/s     8354 calls/s   8354 msg/s
>>    udp tx:    477 MB/s     8106 calls/s   8106 msg/s
>>    udp tx:    488 MB/s     8288 calls/s   8288 msg/s
>>    udp tx:    882 MB/s    14975 calls/s  14975 msg/s
>>    Summary over 5.000 seconds ...
>>    sum udp tx:    696 MB/s      57696 calls (11539/s)  57696 msgs =
(11539/s)
>>    Tx Timestamps: received:     57696   errors: 0
>>=20
>> This can be useful in tracking loss of messages when under load. For =
example,
>> adding the '-z' option results in loss of TX timestamp messages:
>>=20
>>    # ./udpgso_bench_tx -4ucT -a -l5 -S 1472 -D 172.16.120.189 -p 3239 =
-z
>>    udp tx:    490 MB/s     8325 calls/s   8325 msg/s
>>    udp tx:    500 MB/s     8492 calls/s   8492 msg/s
>>    udp tx:    883 MB/s    14985 calls/s  14985 msg/s
>>    udp tx:    756 MB/s    12823 calls/s  12823 msg/s
>>    Summary over 5.000 seconds ...
>>    sum udp tx:    657 MB/s      54429 calls (10885/s)  54429 msgs =
(10885/s)
>>    Tx Timestamps: received:     34046   errors: 0
>>    Zerocopy acks: received:     54422   errors: 0
>=20
> This would probably also be more useful as regression test if it is in
> the form of a pass/fail test: if timestamps are requested and total
> count is zero, then the feature is broken and the process should exit
> with an error.
>=20

I=E2=80=99ll add a hard failure for zero response for TX Timestamps or =
Zerocopy,
or if any errors occur.


>>=20
>> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
>=20
> Repeated

Will fix.
>=20
>> Signed-off-by: Fred Klassen <fklassen@appneta.com>
>> ---
>> tools/testing/selftests/net/udpgso_bench_tx.c | 152 =
+++++++++++++++++++-------
>> 1 file changed, 113 insertions(+), 39 deletions(-)
>>=20
>> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c =
b/tools/testing/selftests/net/udpgso_bench_tx.c
>> index 56e0d890b066..9924342a0b03 100644
>> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
>> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
>> @@ -62,10 +62,19 @@ static bool cfg_tcp;
>> static uint32_t        cfg_tx_ts =3D SOF_TIMESTAMPING_TX_SOFTWARE;
>> static bool    cfg_tx_tstamp;
>> static uint32_t        cfg_tos;
>> +static bool    cfg_audit;
>> static bool    cfg_verbose;
>> static bool    cfg_zerocopy;
>> static int     cfg_msg_nr;
>> static uint16_t        cfg_gso_size;
>> +static unsigned long total_num_msgs;
>> +static unsigned long total_num_sends;
>> +static unsigned long stat_tx_ts;
>> +static unsigned long stat_tx_ts_errors;
>> +static unsigned long tstart;
>> +static unsigned long tend;
>> +static unsigned long stat_zcopies;
>> +static unsigned long stat_zcopy_errors;
>>=20
>> static socklen_t cfg_alen;
>> static struct sockaddr_storage cfg_dst_addr;
>> @@ -137,8 +146,11 @@ static void flush_cmsg(struct cmsghdr *cmsg)
>>                        struct my_scm_timestamping *tss;
>>=20
>>                        tss =3D (struct my_scm_timestamping =
*)CMSG_DATA(cmsg);
>> -                       fprintf(stderr, "tx timestamp =3D =
%lu.%09lu\n",
>> -                               tss->ts[i].tv_sec, =
tss->ts[i].tv_nsec);
>> +                       if (tss->ts[i].tv_sec =3D=3D 0)
>> +                               stat_tx_ts_errors++;
>> +                       if (cfg_verbose)
>> +                               fprintf(stderr, "tx timestamp =3D =
%lu.%09lu\n",
>> +                                       tss->ts[i].tv_sec, =
tss->ts[i].tv_nsec);
>=20
> changes unrelated to this feature?

I=E2=80=99ll remove. Do you think that I should pull out any messages =
related
to =E2=80=9Ccfg_verbose=E2=80=9D?=20

