Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2C20A37A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406489AbgFYRAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:00:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33716 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404011AbgFYRAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:00:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PGssf2029507;
        Thu, 25 Jun 2020 10:00:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=ivK+sQOGsmSlVUl6jzV041/Qx8gRzA0fHwoLcoPEd7c=;
 b=R0pfGnRbjsguFF5g4xkkdXe3lGUJrJ9s6Je9qpELsk2AITskt33VdK68Psq1TKikWteC
 7lz/I89UT6lKEimedALvjLC/3c9bdAYkEmjmrbfOU/KcwzSnn2NZoFYfNIuT3q5X/0ht
 FLDORydhoYVqSB/w+AYmlwUgA8tc4+AmMcaqlwYdRYADZC4cS/z3ECSdAUDd8c3bRoAt
 /aBo2n4A+FFa57Zhh3jxUTvqqdtLVCCPF9d6SBEnFyPoN3BOAcLGFRxziENClkEm4n0K
 u/4Kd5G8yVR1OyCZVL3MO7VMcJF88xNCrYKr5AowyNOB2wG/37+RLjVVjAE0RcT/TjCe qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh0pg1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 10:00:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 10:00:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Jun 2020 10:00:17 -0700
Received: from [10.193.39.5] (NN-LT0019.marvell.com [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 693F53F7044;
        Thu, 25 Jun 2020 10:00:14 -0700 (PDT)
Subject: Re: [EXT] [PATCH][V2] qed: add missing error test for
 DBG_STATUS_NO_MATCHING_FRAMING_MODE
To:     Colin King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200625164505.115425-1-colin.king@canonical.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <e113ec71-64ea-b819-9103-4008d20188c2@marvell.com>
Date:   Thu, 25 Jun 2020 20:00:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200625164505.115425-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_12:2020-06-25,2020-06-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/06/2020 7:45 pm, Colin King wrote:
> External Email
> 
> ----------------------------------------------------------------------
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error DBG_STATUS_NO_MATCHING_FRAMING_MODE was added to the enum
> enum dbg_status however there is a missing corresponding entry for
> this in the array s_status_str. This causes an out-of-bounds read when
> indexing into the last entry of s_status_str.  Fix this by adding in
> the missing entry.
> 
> Addresses-Coverity: ("Out-of-bounds read").
> Fixes: 2d22bc8354b1 ("qed: FW 8.42.2.0 debug features")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: use the error message as suggested by Igor Russkikh
> 
> ---

Thanks!

Acked-by: Igor Russkikh <irusskikh@marvell.com>


