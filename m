Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9C54C3CFC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 05:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbiBYESX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 23:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiBYESV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 23:18:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C017017B8A8
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 20:17:50 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P05x4I022767
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=wLqPAwwsmJ3uw3kYY1DOUApGXRxASuiiJKsPAVZ7RvY=;
 b=DMJK9yxAJq5I9nJzzU+3yRwjvlT7YMNTO7UZAm5KRrsD8ZQG1fnHfWzIE32efX9gQGLO
 elShAaq2PiI5VvBLeKEoPurP+oKB65UrtXf37M0xbHjhKVBlIOfR/bWxRlPx2UJccZNn
 sgTD3uMip4BUki5nkoTaWOXKoJrdJ6fnnAQh1u5kHubigXL2P3pIk7DGAF2AlPOD6/oM
 3HxXRdNIkuMmXLv0GZuGv2Pm7tUJADGIKjlxw0VyOMrcHeHBncerwdVQ84ZAZVJ+V2i6
 MG3O41y3QK6nZTnGe6KMfNazNoPIdyMEB6MR0i4EH6Mbx1RJMX+zdtnaQ4oeYX5r9Ipa ww== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edsjty5nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:49 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P4Crj3014433
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:49 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 3ear6bfjxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:49 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P4HmGp46858590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:48 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA381AC059
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:48 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83384AC05F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:48 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.65.204.104])
        by b01ledav006.gho.pok.ibm.com (Postfix) with SMTP
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:17:48 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 624CB2E0C0C; Thu, 24 Feb 2022 20:17:45 -0800 (PST)
Date:   Thu, 24 Feb 2022 20:17:45 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-internal v2 0/8] ibmvnic: Fix a race in
 ibmvnic_probe()
Message-ID: <YhhYaYPFAuqalEjU@us.ibm.com>
References: <20220225040941.1429630-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225040941.1429630-1-sukadev@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1W1cWevibwCAUhERUjZnk32EWO5o5qSd
X-Proofpoint-GUID: 1W1cWevibwCAUhERUjZnk32EWO5o5qSd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sukadev Bhattiprolu [sukadev@linux.ibm.com] wrote:
> If we get a transport (reset) event right after a successful CRQ_INIT
> during ibmvnic_probe() but before we set the adapter state to VNIC_PROBED,
> we will throw away the reset assuming that the adapter is still in the
> probing state. But since the adapter has completed the CRQ_INIT any
> subsequent CRQs the we send will be ignored by the vnicserver until
> we release/init the CRQ again. This can leave the adapter unconfigured.
> 
> While here fix a couple of other bugs that were observed (Patches 1,2,4).

Sorry for the noise. Subject line needs a fixup. Please ignore this thread.
Will resend.

Sukadev

