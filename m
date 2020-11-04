Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DCE2A6C4A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgKDR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:59:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726779AbgKDR7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:59:52 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4HXkqL018009;
        Wed, 4 Nov 2020 12:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ry0S8lE7aCcBbrMFlZnOC1nefhJ7JoRFCkaP7QYMGCE=;
 b=Z+ojBvHU1bNFmNUjt20i8Xbw0QK0l/un9a9ytBu7Cvo62H3esi96KqkQlHX/o3eviXqg
 C6Mhea2lyhhAvZz8i/VEI41iS7RwqudoBDgBSwTXup83D7nHIA0ALqbrFxxk8pCFUReq
 342K0yw/bC6UhU9FUWRLbB06/pI6le0igk5Q1369f7yxiiTf1TOILKfd2RHYa2s8o4nf
 G1F0M6ewvu6TQUt/wTL+KndJAFmTJdVKn5XzbFdVh+48jql9ptp++RbdFDdbgvaYyCLj
 phdKrn48igFZ/J74YxL1CxXwEC+vWum1kcvoikyr295YPw1ufOtctfPiqjpNXWfG2r2D tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34kxep616q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 12:59:19 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A4HuJdg101458;
        Wed, 4 Nov 2020 12:59:19 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34kxep616b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 12:59:19 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4Hb9Ix030131;
        Wed, 4 Nov 2020 17:59:18 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 34h024rdkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 17:59:18 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4HxH4Y4784786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 17:59:17 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA13EBE053;
        Wed,  4 Nov 2020 17:59:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 773A8BE04F;
        Wed,  4 Nov 2020 17:59:16 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 17:59:16 +0000 (GMT)
MIME-Version: 1.0
Date:   Wed, 04 Nov 2020 09:59:16 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Santiago Leon <santi_leon@yahoo.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/12] net: ethernet: ibm: ibmvnic: Fix some kernel-doc
 issues
In-Reply-To: <20201104090610.1446616-13-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-13-lee.jones@linaro.org>
Message-ID: <1dcfe1124b90cd50d5f9f9fd53ca6baa@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_11:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-04 01:06, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  from drivers/net/ethernet/ibm/ibmvnic.c:35:
>  inlined from ‘handle_vpd_rsp’ at 
> drivers/net/ethernet/ibm/ibmvnic.c:4124:3:
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Function parameter
> or member 'hdr_data' not described in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1362: warning: Excess function
> parameter 'tot_len' description in 'build_hdr_data'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Function parameter
> or member 'hdr_data' not described in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1423: warning: Excess function
> parameter 'data' description in 'create_hdr_descs'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Function parameter
> or member 'txbuff' not described in 'build_hdr_descs_arr'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Excess function
> parameter 'skb' description in 'build_hdr_descs_arr'
>  drivers/net/ethernet/ibm/ibmvnic.c:1474: warning: Excess function
> parameter 'subcrq' description in 'build_hdr_descs_arr'
> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Dany Madden <drt@linux.ibm.com>
> Cc: Lijun Pan <ljp@linux.ibm.com>
> Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Santiago Leon <santi_leon@yahoo.com>
> Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
> Cc: John Allen <jallen@linux.vnet.ibm.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

Thanks, Lee.
Dany

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index b30e1f5784bad..08dab7a94b7ea 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1360,7 +1360,7 @@ static int ibmvnic_close(struct net_device 
> *netdev)
>   * @hdr_field: bitfield determining needed headers
>   * @skb: socket buffer
>   * @hdr_len: array of header lengths
> - * @tot_len: total length of data
> + * @hdr_data: buffer to write the header to
>   *
>   * Reads hdr_field to determine which headers are needed by firmware.
>   * Builds a buffer containing these headers.  Saves individual header
> @@ -1418,7 +1418,7 @@ static int build_hdr_data(u8 hdr_field, struct
> sk_buff *skb,
>  /**
>   * create_hdr_descs - create header and header extension descriptors
>   * @hdr_field: bitfield determining needed headers
> - * @data: buffer containing header data
> + * @hdr_data: buffer containing header data
>   * @len: length of data buffer
>   * @hdr_len: array of individual header lengths
>   * @scrq_arr: descriptor array
> @@ -1469,9 +1469,8 @@ static int create_hdr_descs(u8 hdr_field, u8
> *hdr_data, int len, int *hdr_len,
> 
>  /**
>   * build_hdr_descs_arr - build a header descriptor array
> - * @skb: socket buffer
> + * @txbuff: tx buffer
>   * @num_entries: number of descriptors to be sent
> - * @subcrq: first TX descriptor
>   * @hdr_field: bit field determining which headers will be sent
>   *
>   * This function will build a TX descriptor array with applicable
