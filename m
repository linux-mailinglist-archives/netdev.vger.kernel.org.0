Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E58D49B8
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfJKVNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:13:39 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42490 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfJKVNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:13:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so15841274qto.9;
        Fri, 11 Oct 2019 14:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=CEKCUQt1GgF0uYM1zQl1vGee3IXpbteLdx2u6rvP9gQ=;
        b=cBzAlY5Ad+xaDiOXjfJoKUpH5BmSIvedI/DL7/CkxXlzfqg756lkpn+fp3ktrL+A4m
         7Kq6ovQOYO3sD7FsoxajB0e67G4j7ZSeKVOf18KbIBBK1GuelAhvpjHtYf9tj11328PX
         qYQwwVAAO9J6pRAXfrcnzu2dqfjByvNfWLAmJKg4O9h5c8pXzVVaPa+8RsqeToZ6qp4c
         TW/HweCEtD9YEdZrBzGVNGlpMrznsmXvhaO0Xq1TM218lUp6wdA7Nx+aU7D0vg959iT3
         jcupm4kCAEM25HAY4D1g6RNcdHfgUHcbObnJTdicjJCgaVIn7KnrXnJJiGLocP4bkhpk
         04/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=CEKCUQt1GgF0uYM1zQl1vGee3IXpbteLdx2u6rvP9gQ=;
        b=nzJNh2VezwbRDzUiz54fdF7c/v5l1u5tey2OfbCNbJqCK9j9ucxeh7ojA9LYgDEr5Y
         /y+L9iwx82blBnRvUzy7WlfB2ie4vwfURTupnULbFm19R83Px5w47NWJA32NhYTNjiyo
         g3c8EU9G9SxsdVz7qCGejCEcuXTIMpBIkI7Z1cRh5trDf7WRTA3mDrl7LCgEPgNwhUvO
         R5NFFYagjOIOMLIEQrNHbz1VeYku3bCtEbSCCaYC/UpTyNrfuT1homv6esKUeMcFXDP7
         Kbw5eMujtyS9gwgI1ZW8U2z36n82ER+eS7j/pkqgT2wU6+JiGohuzmi6slihPqWyLVuG
         85DQ==
X-Gm-Message-State: APjAAAUj0SnWAfweJIgjdBohs9Y6QUmB+nCj3wlfT4S73TP2UbmWeYAX
        Rvv9FjpMlTH72EMTFxpta/w=
X-Google-Smtp-Source: APXvYqwO35xVQBtVF6IVZiQUg/mRHU7Z5cfYaLrK9xbKx1+gysQHUR8U1UhV7HE+9IhjEvnmR+OG7Q==
X-Received: by 2002:aed:2796:: with SMTP id a22mr19043514qtd.324.1570828417432;
        Fri, 11 Oct 2019 14:13:37 -0700 (PDT)
Received: from [192.168.0.12] (179.187.15.68.dynamic.adsl.gvt.net.br. [179.187.15.68])
        by smtp.gmail.com with ESMTPSA id 92sm4286809qte.30.2019.10.11.14.13.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 14:13:36 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Fri, 11 Oct 2019 18:11:36 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20191011203716.GI2096@mini-arch>
References: <20191011162124.52982-1-sdf@google.com> <20191011162124.52982-3-sdf@google.com> <20191011201910.ynztujumh7dlluez@kafai-mbp.dhcp.thefacebook.com> <20191011203716.GI2096@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH bpf-next 3/3] bpftool: print the comm of the process that loaded the program
To:     Stanislav Fomichev <sdf@fomichev.me>, Martin Lau <kafai@fb.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Message-ID: <37176EA5-3E3E-4405-9823-5D7153998DF2@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On October 11, 2019 5:37:16 PM GMT-03:00, Stanislav Fomichev <sdf@fomichev=
=2Eme> wrote:
>On 10/11, Martin Lau wrote:
>> On Fri, Oct 11, 2019 at 09:21:24AM -0700, Stanislav Fomichev wrote:
>> > Example with loop1=2Eo (loaded via=20
>
>> What will be in "comm" for the python bcc script?
>I guess it will be "python"=2E But at least you get a signal that it's
>not some other system daemon :-)

Perhaps bcc could use prctl to change its comm before calling sys_bpf and =
set the script name?

- Arnaldo

Sent from smartphone

>
>> >=20
>> > Signed-off-by: Stanislav Fomichev <sdf@google=2Ecom>
>> > ---
>> >  tools/bpf/bpftool/prog=2Ec | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >=20
>> > diff --git a/tools/bpf/bpftool/prog=2Ec b/tools/bpf/bpftool/prog=2Ec
>> > index 27da96a797ab=2E=2E400771a942d7 100644
>> > --- a/tools/bpf/bpftool/prog=2Ec
>> > +++ b/tools/bpf/bpftool/prog=2Ec
>> > @@ -296,7 +296,9 @@ static void print_prog_plain(struct
>bpf_prog_info *info, int fd)
>> >  		print_boot_time(info->load_time, buf, sizeof(buf));
>> > =20
>> >  		/* Piggy back on load_time, since 0 uid is a valid one */
>> > -		printf("\tloaded_at %s  uid %u\n", buf, info->created_by_uid);
>> > +		printf("\tloaded_at %s  uid %u  comm %s\n", buf,
>> > +		       info->created_by_uid,
>> > +		       info->created_by_comm);
>> >  	}
>> > =20
>> >  	printf("\txlated %uB", info->xlated_prog_len);
>> > --=20
>> > 2=2E23=2E0=2E700=2Eg56cf767bdb-goog
>> >=20

