Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2006559C9F9
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiHVU3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiHVU3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:29:13 -0400
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC91151A04
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:29:10 -0700 (PDT)
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
        by mx0b-00364e01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MKSpkT024693
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 16:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=RO6XnNaJa5CLPESo4BXMgCV8xs+Ov+oCGIYJUBbQBFE=;
 b=mu8+NDuumu4WlBmynPceEpgGZ3/uNMmxh+3oomQ5V4IDiK7YH3nO0MnF4Usu76ADPpBh
 OFIovx+0CQCiz9zOKMU0w5tVQuXtH0fxJzjO+QSM/wMMUUp/iXxczikJAF34V56zWIer
 obK5h0p8kLgzp6engoK8s3oWqhvitdhXu1cRdaYTFj4cfKck41OCHT2RreJXqaM77LiD
 Fu0r8KlOrwcUQcDSXx1dlZmt8wF5B6hnUfi/IebNyZJsdRvtSnvqsK9E6FZMhxR6t8Ac
 MZzfaaRb5exnAM7r/CpiFt2ptjJlInRYPOnt2KILrVDJnLouFvRbPHzQysBGlz1h3CiG qw== 
Received: from sendprdmail20.cc.columbia.edu (sendprdmail20.cc.columbia.edu [128.59.72.22])
        by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 3j2wj7nc6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 16:29:09 -0400
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
        by sendprdmail20.cc.columbia.edu (8.14.7/8.14.4) with ESMTP id 27MKT9VF075575
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 16:29:09 -0400
Received: by mail-vk1-f197.google.com with SMTP id l134-20020a1fa28c000000b0038314de4652so1971433vke.13
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=RO6XnNaJa5CLPESo4BXMgCV8xs+Ov+oCGIYJUBbQBFE=;
        b=Y9Q5c3D0eITyfFMB09U1iHVX5zTzYUy/Xvnb30bLESFIP5gt4uHFQh8HQacTmCEa9F
         M7A1zKeFV3+n9J9khtNcKxfL8AYqtddgReNNmBjupsqrj0QeUasDMXa4d+yxo0bdRr5Q
         zlCSRNGpbWJD8+hi/Mx4LAhEX0CkxEMs8AnYKtKcnJy6JIrXTGBEDPwVPQGfLCwk9quh
         tvuQ+q8QqZJQvYxfbkwSjDvdFjEKEozTEGeBAjMqYDRZZQUwYhV5Xt6JLKxNY2uvlI4U
         9kg8T2tmotE49lOGWTupeoyU+KwQWYz3O2LaEbtWlXd8jm42KqQs9GEjJgLTxL1fFLHA
         5IOg==
X-Gm-Message-State: ACgBeo0cfkrB+ZHOXvx0m3GS6H7HLpODBeDvANMuowgVZLpBWk2QsTOs
        d1kzyHl0y3rEkRePKrTeMK6euWHiqzdFNCZl5Q3lyAV8wZN7uWZr2zqPuu4+KQ4vysRAgi9BuSu
        SdFvAbCFQf9lMGCqcxaT0VebFi6NXiI0DUSB+DZ9t
X-Received: by 2002:a67:d493:0:b0:390:4c24:804c with SMTP id g19-20020a67d493000000b003904c24804cmr3487913vsj.71.1661200148782;
        Mon, 22 Aug 2022 13:29:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6qAuh4CBQQNbGpkDG+XPmmtL1rFL2gufNf/IROiaU3yjSyNpB7b9ZKlVkr4paudFC/qWGrCOIFqO6h9/Vqt60=
X-Received: by 2002:a67:d493:0:b0:390:4c24:804c with SMTP id
 g19-20020a67d493000000b003904c24804cmr3487895vsj.71.1661200148572; Mon, 22
 Aug 2022 13:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAEHB2488dNqBKcgWLSeq500JLC1+q6RV=ENcUPm=rN9bWf0QkQ@mail.gmail.com>
 <20220819123542.GA2461@breakpoint.cc>
In-Reply-To: <20220819123542.GA2461@breakpoint.cc>
From:   Gabriel Ryan <gabe@cs.columbia.edu>
Date:   Mon, 22 Aug 2022 16:29:01 -0400
Message-ID: <CALbthtdzW-_4TVngjt-VjCS6GqCEP967-UE7oEoDkBAVaRFOzw@mail.gmail.com>
Subject: Re: data-race in nf_tables_newtable / nf_tables_newtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Abhishek Shah <abhishek.shah@columbia.edu>, coreteam@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kadlec@netfilter.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: mH8NkG2KnbVAO11pTnFn7NYtW1bFHQBd
X-Proofpoint-ORIG-GUID: mH8NkG2KnbVAO11pTnFn7NYtW1bFHQBd
X-CU-OB: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_12,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 bulkscore=10
 malwarescore=0 lowpriorityscore=10 mlxlogscore=999 impostorscore=10
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220082
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I just looked at the lock event trace from our report and it looks
like two distinct commit mutexes were held when the race was
triggered. I think the race is probably on the table_handle variable
on net/netfilter/nf_tables_api.c:1221, and not the table->handle field
being written to.

Racing increments to table_handle could cause it to either overcount
or undercount. Could that be an issue?

Best,

Gabe

On Fri, Aug 19, 2022 at 8:35 AM Florian Westphal <fw@strlen.de> wrote:
>
> Abhishek Shah <abhishek.shah@columbia.edu> wrote:
> > Hi all,
> >
> > We found a race involving the table->handle variable here
> > <https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__elixir.bootlin.=
com_linux_v5.18-2Drc5_source_net_netfilter_nf-5Ftables-5Fapi.c-23L1221&d=3D=
DwIBAg&c=3D009klHSCxuh5AI1vNQzSO0KGjl4nbi2Q0M1QLJX9BeE&r=3DEyAJYRJu01oaAhhV=
VY3o8zKgZvacDAXd_PNRtaqACCo&m=3DxlZC-wDg7fkTm6_4HfcoDqYfJx_OU2L5HHX2q_yTYZZ=
CEDCFAg-9I7T1gNmXPISg&s=3DJYkSOriQVx_3lJhAzBo7yqhe4bnf2Sy96cPL0L1NIn8&e=3D =
 >.
> > This race advances the pointer, which can cause out-of-bounds memory
> > accesses in the future. Please let us know what you think.
> >
> > Thanks!
> >
> >
> > *---------------------Report-----------------*
> > *read-write* to 0xffffffff883a01e8 of 8 bytes by task 6542 on cpu 0:
> >  nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
> >  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
>
> [..]
>
> > *read-write* to 0xffffffff883a01e8 of 8 bytes by task 6541 on cpu 1:
> >  nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
> >  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
>
> [..]
>
> I don't understand.  Like all batch operations, nf_tables_newtable is
> supposed to run with the transaction mutex held, i.e. parallel execution
> is not expected.
>
> There is a lockdep assertion at start of nf_tables_newtable(); I
> don't see how its possible that two threads can run this concurrently.

--=20
Gabriel Ryan
PhD Candidate at Columbia University
