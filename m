Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B936D333949
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhCJJ4J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Mar 2021 04:56:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:59113 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhCJJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:55:45 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-196-icghlii5Ppe-aK3eY6X3oQ-1; Wed, 10 Mar 2021 09:55:39 +0000
X-MC-Unique: icghlii5Ppe-aK3eY6X3oQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 10 Mar 2021 09:55:39 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 10 Mar 2021 09:55:39 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jiapeng Chong' <jiapeng.chong@linux.alibaba.com>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] perf machine: Assign boolean values to a bool variable
Thread-Topic: [PATCH] perf machine: Assign boolean values to a bool variable
Thread-Index: AQHXFMyuUkzqglnwCE+oJIwnabqrBap8/PsQ
Date:   Wed, 10 Mar 2021 09:55:39 +0000
Message-ID: <e28b0392ce4349989fdf03470ed8fd3e@AcuMS.aculab.com>
References: <1615284669-82139-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1615284669-82139-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong
> Sent: 09 March 2021 10:11
> 
> Fix the following coccicheck warnings:
> 
> ./tools/perf/util/machine.c:2041:9-10: WARNING: return of 0/1 in
> function 'symbol__match_regex' with return type bool.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/perf/util/machine.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b5c2d8b..435771e 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -2038,8 +2038,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
>  static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
>  {
>  	if (!regexec(regex, sym->name, 0, NULL, 0))
> -		return 1;
> -	return 0;
> +		return true;
> +	return false;

What's wrong with:
	return !regexec(regex, sym->name, 0, NULL, 0);

    David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

