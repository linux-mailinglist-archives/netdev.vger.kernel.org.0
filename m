Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3B1D8D3E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgESBmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:42:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63784 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbgESBmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:42:42 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J1a7ln007196;
        Mon, 18 May 2020 18:42:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bc2qKunowKhFaVT/J9InA4DeLGvW0kltooCybuV/HI8=;
 b=JKQce6L8cDVX2eob/aCILK5CBBJwxedqf3xtJdrq4zeVx9sk/M/GMLNCxckz7BLHyt6H
 /9Bd/pLXQFfw7H6jpn17vY9HEzzIK9ccx7bgMY0Y22rw8Tiz2nN0YJu5aQCaPtKH/TBF
 W7p454QswQJC+VBRZRnfzIEJDK8NxZS2Ufw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 312dpx97ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 18:42:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 18:42:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9x2C8vDP64VYjloIgM5sg0uHDG6OfX+AF8OY5Wypk4uGO/Z8BgimO8s2Q7U+D3U1VpjRBLzmsbUDbQ3CisG3879B/dSSxhZwnE75T6Axi8UEQ34//4WjiJ2PHy9S7EmhpCpBQRho4y09XpEuB6mwXqH9aIrOgX0AC7y/9ogSPszBQkro+rqcBzKN/J3ped+8GT5UP/3tcBTeoV16/7ygCaVSrXK8gzqylN8+LkXse+vJ1iz/IndOb1U39T+DoFFfoLPxqe0TxQ86/poiF8ih6kabEP58OOYHC4dfE3FY2gNEPq3i2pofFrmYO+KTvZj0hU6nlSLOBB2nqFq7HeiPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bc2qKunowKhFaVT/J9InA4DeLGvW0kltooCybuV/HI8=;
 b=dcBPDu9UEcc7bMDdun8iqs5K9ZS6fWD5YW9ZTkMy+jFMAgT6HRCFKV7Dazieh2ItpkNg2lz/qq1FFIowjR1dH2jRweVeVQpsgb1pf49ZNRpCUz6dr2JuNLGvZb6itkI3SKPCEr/TUyPMSr7770bFF9RTuLMjefcPKoSJgOB87rnpnj0RgDABqtRZLAuzMsmXoOW0PGZl4dynZjsgrlZeR/H1hiV4ifSCm/C/4t9M1dy+rcqKHpjU21luom/Ts6cF6DX6AjivIrFFM5M+N/9tiopb3TUqEsqAZiFFBZOLSlUncCo/CfJ6rK41U0uhRI22tvYiBn2uJZLuIKHTOmh13A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bc2qKunowKhFaVT/J9InA4DeLGvW0kltooCybuV/HI8=;
 b=T6D54SnZz0CnLtrdR6EEPxIQH45dXh+a+KbDSXcwDDLKss/iJP5akXymXpYxNpsUHxjKfIwSWyGJD90SBIpuSXg2S+8tqKx1LYm4kwtzgxgbJlUiaqzHkLkoXCFRO2mrptdpkXqc9Cz49F1aqaiMspfXG7MOvPOYaJDWledfD+I=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 01:42:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 01:42:26 +0000
Subject: Re: [PATCH bpf-next] selftest/bpf: make bpf_iter selftest compilable
 against old vmlinux.h
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200518234516.3915052-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6633a04c-aab4-5182-2bed-28b235436932@fb.com>
Date:   Mon, 18 May 2020 18:42:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200518234516.3915052-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:f205) by BYAPR06CA0003.namprd06.prod.outlook.com (2603:10b6:a03:d4::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 19 May 2020 01:42:26 +0000
X-Originating-IP: [2620:10d:c090:400::5:f205]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80b7abf-9944-4bc0-14aa-08d7fb95e282
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB319249A26ADE03642429E332D3B90@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cEch0uouj3t8GUtxdkxiEP2z06ID8QZ+LtjOFPBYqb0qi4j2oTJg1L/BjDtFQBaJ9OaXpwSc2vlt/L7vLsOrJDWjqJwCUIZxvr8O0xlg3itEgfc49pENjvGBU2ELLmqrLe3JHjcwPyJVg+rpSUiBVjhAXirBHS8OjXKF7BXO8nvK1tlL7/RJef/xZxkBSHCDF6QDHFWWTPb5jMBOMpqeuAB2LgRVVzYGoLptWdO1lhgOfguZti7QvDlYWochdNvylKHI5BsFijlT/J1FGYWJ/okTK2iQe5+toy2bFHHRqpUjZbGoJ2enCEgs7SbFy/STgp674SuxpyFBCjdnWlBNmHOebDDcP+z8JCcUf+sBOchUQoycdmmYZhDEM6sILprSPDkqKfX/eUsYcldi3PAv5joSfakVMHWk3X9WKyVB8mY1/eVhHBHKeLBgvGOzFcETlYkMjQB+CLHpDFyJtBW5Hv7ddvkmZsZ5Fa2/Cn/0Gji2MzcDJhR+ppvD2+qeY/jp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(31686004)(6486002)(4326008)(53546011)(6506007)(52116002)(8936002)(4744005)(66476007)(66946007)(6512007)(66556008)(36756003)(86362001)(31696002)(16526019)(186003)(8676002)(2616005)(316002)(478600001)(5660300002)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 03VW8I2wd3ceFIYV6VjWykqjoG8UsAsnptzwhe9UUMXvdfyT0XWxYzBxk0xKcQQW+lA2bP6B+qMKIKcHwL/EHbsNq+THkTVZ3uS0HGSB0pwirfe4EjITc7W50HRFs8DWUWSDN9Aw6kCry8JAVrYtGQ2DlwIBvFQV3czPV/72sA3zXMQ+q3rP9+erjfB0Dx87M3CWuRy/BLhfuAID06VVzep95wTSmw6VNZ8NrS3MzKeZJaFX+SuEF+mK1gwfExrJSN3yDrvYm0cxyqVsG+7m77qFfj8Cx20ZRrjtzd/sGj2fpBLvJ0GTSqmz7ohvUg4xAKRAZU5AE0Oc+HrYp9pt3lZFa9/xJ0udls/4ls9F4ryhIDGJtV7xeHp0MnbGexNUXhwySmhN5RWkFV7tK9XkfHAfobS8R2qsKSaNy57cSSZxud9/oFxLaWw2A4zC6RvDk6P3GSFPWpyNA6QiVCmznBQDSPvTJycrQHagPRW4rGvc/uvjSHwjn/cv4BJpzUAQ710h7XBY5DTcI3rivZsi2g==
X-MS-Exchange-CrossTenant-Network-Message-Id: b80b7abf-9944-4bc0-14aa-08d7fb95e282
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 01:42:26.6468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyQgDrTLN8RoRu7zaId90w5Xk4ASut56hgB3CXgSHAy4XLP0obX0lPFcyVl0vgA6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_11:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=912
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 4:45 PM, Andrii Nakryiko wrote:
> It's good to be able to compile bpf_iter selftest even on systems that don't
> have the very latest vmlinux.h, e.g., for libbpf tests against older kernels in
> Travis CI. To that extent, re-define bpf_iter_meta and corresponding bpf_iter
> context structs in each selftest. To avoid type clashes with vmlinux.h, rename
> vmlinux.h's definitions to get them out of the way.
> 
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
