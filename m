Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5B1F9177
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgFOIal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:30:41 -0400
Received: from mout.web.de ([212.227.15.14]:43235 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgFOIak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 04:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592209820;
        bh=gJSDf66UIv9lJIjZ6iwA+toPmjiCWe0MzdTiede4Dcw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CCoxy4lx6KUxnprFGaV79M+IeDrpq/2+tStPTpYaEjSp2/1jwlsIRXq/81gXgwDaf
         N1iCx3M0p4cSce3d8ziw5lgSGl1fST3A43tmwIUEV/GewhcjUKp6C2Nq3YuY/KLKlg
         gsHVek6NFWQ52q4T9yxHVLePMGhWM6FhwUe8dTzo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.107.236]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MLgTT-1jjvQd1Ev5-000phK; Mon, 15
 Jun 2020 10:30:20 +0200
Subject: Re: [PATCH v3 0/2] Fixing memory leaks in perf events parser
To:     Chen Wandun <chenwandun@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200615013614.8646-1-chenwandun@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <1ee927e5-2bb6-a72c-8705-95bc6cacf719@web.de>
Date:   Mon, 15 Jun 2020 10:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615013614.8646-1-chenwandun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yocFRMxAiW6vS6YQh4Ww8kFFOmXce7o6fqR3Itxi1Cly/DNGLND
 Z3CfA17YsMfwOsfB6pxPMwEZDGyedgnk3xwQUdobhinBS0z1HOTrgsAK5QRVwS7yJSNd6xz
 MGOmXeKu6ule/OEwxKeWxU+ElpvdyIY1QUNagQ3Jr+j39U+5DKTPS/jD6hyUE05tkHrDUna
 m6La2D6aANETmgjzzV0GA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7K9w0tX4hls=:FtCh15c2IyQSe17BdT68B1
 Orcc7GVq9Q1CtqJUO94r1qBFzGI+PqSf0AhVqoFhxxmv3s8lZhRpyLasFds154Tox5/WRHvxr
 m38jB6AkUjp71L9SkDbq+dZINChjBuEiDCPmKzKuB2bhdeOHkgZL/zEBmBsGwPz2+hMpQ+sUG
 h6VDLqsx19OgKS4df3NECYRnkb8+HCFUW3J4YgP1XcuqftIej6Dp4Q9iKdLnEC26Rwyw7yRWa
 L/fJ05l3BHmpFNkPgsUjnaaMjrc47sQiRjF3xq3YbS9Lkpfgsts8SWX6JSWRKoejUf42vMXZk
 bAmKzj7g1mikkqXaBAy/fdUdDVN+8OVfVnuqZSWEmW2rmyKEzdKhm0IHdaZVtb18Wi4sk9vlj
 sLJPgxCj6nZQpuycwRLZM1G49NsQ4C9H/2CT8S3MxrEj3crHIOWg6gH/bOXYNpcUwGM2hlbum
 xUtni7T3wBkIK8oaW2r+jgy06z+s9Dzd9ouIFUsC/UGV1EdtaYK+hslFNSOiIdIkdKzWM6jP+
 PKL5muLo898TaDrYbRq1ScFhRAT6TgG0LBCJgdqs9GFqtOQAGZlwg8vi5CZvOYM6wxhwKBpOu
 YfddZnivK4m1mgVBgVewaoBhSCCAO9gGS/iSq/vDz8NdcIJcsVI5Bg7XQWjaCVPdEj1/JuD+s
 ymrxdDSjyD2SagjZWJ5xRXfRocv3HrQVsCUJYkwN12g/z4EvQglQMX/ygKVkewexvrSGvyOor
 YGY5gRRxC4cx5GUni5azyomufc/qeNiBargzyGV4yMKLYAQZmCrPp3sFKnHA1Z+QIsi6snM32
 iz/W7MBw/6yHs2+Bmw/NvnycyLVP2NDqwiNH9om6vy4ExnG8NPCH+p5aqKygN8rqp9RrdKfHu
 UqX1IxtSBO+IOkYGDCRzAIAUNHI/50kAU/v8bdmTHvk4uwTwS0nUA+VzGBkQPOMzDdcF+yFqS
 AvbXLKmX7OqVO9G+ZOCctE+SfHE5yHcF1t8eOkseoGvZdxnWtCFfrO9UAbUW85Q/9JR3YaiaV
 BOSlqZy5CNH6fx6Xm815ScIM81K3pdtcllU1inj5kpL4HyQsqn6kfS9Qe56KTivcL+pvOhWiL
 S1zkQvAfWxzNAeXVIUigp1r/xLRTcpw9FgekSfWf6Ei/npgf4KgvSBYVewfd37/vKrb+kMCxT
 E9FUYsi2WI+mjYdpqAd5RCun1LH6Wdaw+Rez3VCNTwhyR0uL9XxWtCABPvW49YR8JxzC08uH3
 Kf6DvQejCapQ4KY4A
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> fix some memleaks in parse_events_term__sym_hw and parse_events_term__cl=
one.

Can it be more appropriate to refer to the term =E2=80=9Cmemory leak=E2=80=
=9D in consistent ways?


> v1 =3D=3D> v2
> 1. split into two patches

Corresponding development consequences can become more interesting.


> v2 =3D=3D> v3
> add more commit log.
>
> Chen Wandun (1):
>   perf tools: fix potential memleak in perf events parser
>
> Cheng Jian (1):
>   perf tools: fix potential memleak in perf events parser
>
>  tools/perf/util/parse-events.c | 51 ++++++++++++++++++++++++++++------

Are there any chances to make the change distinction a bit easier
by adjusting such commit subjects?

Regards,
Markus
