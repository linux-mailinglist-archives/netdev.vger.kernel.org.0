Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2BFB1DC8
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfIMMhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 08:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9287 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMMhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 08:37:52 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BFD2C08E2A1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 12:37:52 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id q3so6201918lfc.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 05:37:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=74C0MUNo5cSA21e3pNIqhnNnMlBiYbmaqmQEdGDqJ58=;
        b=YZe4x2GeWVEELKy/EUxy/no4RZMNRVsI06TxY5b0jyTJHkY+WrigzAEh4o0MKnHfa3
         ogY5esVKU527C8011gxHrm0gVOkYWeQEFgSqVDR5gR1AvMe79QeV1CYZ+oQE7G04MTL9
         mgZR3TnSvV/u43cYrhKFD1wMQaRXKCe+06P+7XdmKMWy/j69WLPkXyZBuPnp4ZciASO6
         Cb1vMDoscD8OLF7OIaV+o5sHMDQ4giuqEWyrbeeN63ZZZUP1PkR6hUI2tPCIuBd7LT7I
         q07oGXkltKVvA/n9N5cgSNTH+QagoEwk6QNi4uCjq/YyFEIDCF5PPLLSixmlTNx/g5QN
         mLZA==
X-Gm-Message-State: APjAAAWxW2keN79VY2vVaWYgiw1cy0pB7woPpWNC3DIv+5maYf2+g5d4
        0tgZnvSb9ef60DUW/oylgNCoUoP3d60/axfgHnLDSUjEuVh6g8JEBeAuKhAKR/YAdO5IKmbTs3X
        bzS/rGoi2hwVTwSlk
X-Received: by 2002:a2e:88d5:: with SMTP id a21mr15045854ljk.17.1568378270834;
        Fri, 13 Sep 2019 05:37:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqybIhqji5YdYuD7MboonLmoCHxAmwO6u65Oku2WrZMp8ZrJ65f22yfgHH1LM9yCL44Q3E7t1Q==
X-Received: by 2002:a2e:88d5:: with SMTP id a21mr15045848ljk.17.1568378270718;
        Fri, 13 Sep 2019 05:37:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f19sm6825221ljc.72.2019.09.13.05.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 05:37:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 72C6C180613; Fri, 13 Sep 2019 14:37:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v2 3/3] samples: pktgen: allow to specify destination IP range (CIDR)
In-Reply-To: <20190913143144.2b8c18ed@carbon>
References: <20190911184807.21770-1-danieltimlee@gmail.com> <20190911184807.21770-3-danieltimlee@gmail.com> <20190913143144.2b8c18ed@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 13 Sep 2019 14:37:49 +0200
Message-ID: <87ef0ks76q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 12 Sep 2019 03:48:07 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
>> diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
>> index 063ec0998906..08995fa70025 100755
>> --- a/samples/pktgen/pktgen_sample01_simple.sh
>> +++ b/samples/pktgen/pktgen_sample01_simple.sh
>> @@ -22,6 +22,7 @@ fi
>>  # Example enforce param "-m" for dst_mac
>>  [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
>>  [ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely
>> +[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
>
> The way the function "parse_addr" is called, in case of errors the
> 'err()' function is called inside, but it will not stop the program
> flow.  Instead that function will "only" echo the "ERROR", but program
> flow continues (even-thought 'err()' uses exit $exitcode).
>
> Maybe it is not solveable to get the exit/$?/status out? (I've tried
> different options, but didn't find a way).

`set -o errexit`? :)

-Toke
