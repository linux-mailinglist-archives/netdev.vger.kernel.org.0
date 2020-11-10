Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FD62AD8AF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgKJOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730666AbgKJOYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:24:15 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E008C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 06:24:13 -0800 (PST)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEHcAl031897;
        Tue, 10 Nov 2020 14:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=oCGr4fgJW3o/SE2HATKUD4/QqNol/ai5B5sgadcB1eQ=;
 b=nBG3dFAV4KshmV7mFDici7ZQy88rrKmk4EpODEXMq9Kv5G6vtB3TGJ11lxgbieOe1azX
 sPUKXuJ/xXd+DOo108qDtfZ77QRbVBIGGFA/f0Hf74KTGZ21Fg27qYRIpWmvFF661LSX
 Nr2RdJkMzt43+rC4I7gNc3Z/hJyq2PZTiHtfbWKECBYLQ4EBeu1wnW2QwBwrKfqKlex9
 oEf5YZkGVCtZDegnxXNoEUWtzsZtndwENiNGUBq4lPTDw/r6UOMiSww34adXeAhxmKfN
 UbNfI5Tk2SPjl1Z/GX90AWWJsjwgCpQ07Dsp7naXfjzB34YADy7Q0KG2GpFw/QS6Tz9p 0A== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 34p2bm4sfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 14:24:12 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEJiDP026296;
        Tue, 10 Nov 2020 09:24:12 -0500
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint4.akamai.com with ESMTP id 34nqt3m196-1;
        Tue, 10 Nov 2020 09:24:12 -0500
Received: from [0.0.0.0] (stag-ssh-gw01.bos01.corp.akamai.com [172.27.113.23])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id C84D46050E;
        Tue, 10 Nov 2020 14:24:11 +0000 (GMT)
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <20201109025052.23280-1-jdike@akamai.com>
 <50c52b3b-9bf3-6666-df4f-a30cbffd208f@gmail.com>
From:   Jeff Dike <jdike@akamai.com>
Message-ID: <4dead009-92f9-6e73-5af0-3fd454643f8f@akamai.com>
Date:   Tue, 10 Nov 2020 09:24:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <50c52b3b-9bf3-6666-df4f-a30cbffd208f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=935 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100102
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=839 phishscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100102
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.32)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 11/9/20 10:55 PM, David Ahern wrote:
> ipv6_addr_type() and IPV6_ADDR_MULTICAST is the better way to code this.

Thanks, will fix.

Jeff
