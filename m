Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17CA20EBD3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgF3DI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:08:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56256 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbgF3DIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:08:55 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U35eeo014156;
        Mon, 29 Jun 2020 20:08:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cyZb3aPOYOVfqoGRrEIyq20ZZgKVd8qrAByrDKIHu+M=;
 b=fVPZx5sHsO6D/rAa1TxA4JzCH03YLtNVMNGerXGbH+uEq2tUF8QmJ+xbjBXpKS1Bz6Fi
 kvpPUK4gWzzSHyD5XxpzMc9mgBYNhDH5qmH4VBEmN01hAnMbXwwuTVs+t6uu+MyQAbkw
 x19zJpkHWpTKkNDacmXmL4qY2Nu9KI4J8hI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3upjakv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 20:08:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 20:08:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFsA7eELUNQX3axgcgNTJmfWcoWQ3tMA58pHS3HZvhrmOqMRSCHlG5bkyQzoi0mGHMTHpaQph96k2e87kPejLaBNwg9fYBFUx4pxfaTBeenXmA7Egcsk3VA7l586fPG8x59oMH9HPNtYZNB/iRQ/ZuPMCGOyWDaMRokMKSkEdSiBX9fCe8LBrQULV2+2e3s4yERnQvq+uhNYyl4XeajteQ/2Q0TqWcx9ToN8QH+wFBgbIRqsg9VPZqRyB+i5N1kL/iekA14YaUUFXFUHVIzt0FTQ40G2qYoOy2x3UrQ7b44lTgn4KhxTB/JZDzCT9wer9rRRpHQHO1AbJgwTUME2+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyZb3aPOYOVfqoGRrEIyq20ZZgKVd8qrAByrDKIHu+M=;
 b=oKrVDENeA0WaKWP4Nnr/fWCcTMzCGxcQ1e+sjSdNzU6HBc9RVvhrVlfOKAWnHMRo8qJU9Jcr4KZP+U97AvR56YjyPHz+zlf97XS/nU6Sdh/1URX28Vms6+AihRZk9O90Q+CxdRpQRYbuQ5JHeWTb2E+F1wlaUu7rhJNjwx5XuuaOlPyUjc+oDYC0q5SMO/wSdvZ76mThtQreuigCmxt68+DM8p8xDUzq1u05v5rZtjNI1XmMkyIpZg0F0L9OuwbyBPb55nZmBjgoyp+ELskWfrW4x6mssd7G+TYhS7HJDYAmP+aUXS3/4vbNheS4l25s80z+AN2Zgy69/9xy/oB+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyZb3aPOYOVfqoGRrEIyq20ZZgKVd8qrAByrDKIHu+M=;
 b=LQSlB4Ol0g6UZq90ZJ1LR07JHWBZj5015vUruYFn/td7q9Y1AlsMGI2bfNfrfgTv+L5i2XsnyYOxJGsSTX5c0607kI/N6EtMP76kUD/zhvGCUq+NhqtjHDqQN7h8yErob+lf02ST2TSyC+8syZbk3NI3JxseS453wtvVSgjNrHc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2949.namprd15.prod.outlook.com (2603:10b6:a03:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 03:08:40 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 03:08:40 +0000
Subject: Re: [PATCH bpf] bpf: enforce BPF ringbuf size to be the power of 2
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200629221746.4033122-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0afa8e51-594f-275d-c9df-112606742523@fb.com>
Date:   Mon, 29 Jun 2020 20:08:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200629221746.4033122-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:46d9) by BYAPR06CA0035.namprd06.prod.outlook.com (2603:10b6:a03:d4::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 03:08:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:46d9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0db8e66e-2af0-4ea0-70b2-08d81ca2e3ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB2949:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2949D78DAC4313B6721DA86AD36F0@BYAPR15MB2949.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCyO9D+FaJDdr2XVObgonINX0JvfqrNXtEpUX2z0StvhLCfzGdyGIa+7NMZslWOCuoj2f6zRu0lGBQxPiThHn1l8UwCdsK0nJWJBwC39/hR5zVYFFSthfth2paMzXNphzm+9RSPkHgAkDsIPycUdrcdu4SHgVEw/wsIQwPPTVARwLasctrcXUBf8RLXIvu5nobGb4joBMbXa2bpw0aoTJJMjsMQj0TZaygkDY9X/RfCLBu6JOG46hX7y6FNFqzhlbSvtxy3XGKb/no3cby+yHNDDWts0gvWc9V4fGjT1tCuw3vU2/mkxvgmnFcA62tAwrxaOkX6moS6Z/IxBvmyLunkRO6LMBmSth9kY1PkB0SxWFWbfTM17TyEV/gvX7o1L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(31696002)(316002)(478600001)(5660300002)(4326008)(6486002)(53546011)(66556008)(2906002)(186003)(16526019)(8676002)(86362001)(36756003)(52116002)(31686004)(8936002)(4744005)(2616005)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cxPD1N2muQ/+PJDsl7dBjJOLkeu1KABw/bNoSdERAbxlBWUqLwsLj1OfRfDvy4zNo8kNx1MgXnSMCv90RRDQXfSPBiz+2OevVwvwBgAqxTNDv+kTDzRzdTERGIyoQq6EpIG/rp2XScunLuo2ohA70R/X7TDCS6Y+nEm9e3FzpcJpq3FuC3TXm0odSKz7B+0T/t+MY7PxLVt1MnZbZoFjAkaT+I3z2LdO4joYdH+OjqQj4tNXO9hyBac8tOIGYdfcmM5C4DJ/OKm/pcN3uT98Yp1uf0l4ma2+4lT0cxHKdO9iZWcqpbZ+v5R3pjcaIwgHC7dG0mXONOjp09jjuZ+JceQ9znwKIp5lprxPoaOZqdjFdgcaqtP+YXZ4EBlKnimaYlzwPkg6XlT7AkjyGeuXIcjyy7IHXKwRAJ6atMS8M752piJ0wdwndvHY8SmM2KMJbNItTyUl8w3o0/98Ovr7WicxpMazlwLVm/0eback7T2e6x5+c9U3fR2VTdP1chM4CSJwqGtN7LBU6gYjdsz01A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db8e66e-2af0-4ea0-70b2-08d81ca2e3ab
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 03:08:40.5656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq71anrPHchA/Kj3j7OGNAz8W6aBPVZHR9AgQ80dYWBiaeoMEPtIby/EKQOWVj1L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300022
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 3:17 PM, Andrii Nakryiko wrote:
> BPF ringbuf assumes the size to be a multiple of page size and the power of
> 2 value. The latter is important to avoid division while calculating position
> inside the ring buffer and using (N-1) mask instead. This patch fixes omission
> to enforce power-of-2 size rule.
> 
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
