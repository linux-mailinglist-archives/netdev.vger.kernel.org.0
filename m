Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D651CA4E9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgEHHOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:14:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgEHHOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:14:01 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0487Dji2004499;
        Fri, 8 May 2020 00:13:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=a2SvFJSm6dzdn1l2v3uFDu7bAs1QkUQkQ76Lpn5kD00=;
 b=G6hXMTaTrCe0coSxUgyyLQ/QbkPKD2MnA9IfjHUdP97JNDvYOCX0yJguRC06ZYbi2t46
 8Oz36vkFkaaVA63zNVbBhogh9Mi/6rOmcWtDQzVMs8kmUxeWSgK2XFPmsk0CfrjL3hSn
 IfFOl3TB4hlvhHrEm2RJGU6TXksXYv6TyL8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30vtcat5ha-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 00:13:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 00:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ql1+8w2zUnc5OnP+QeKb0YmpcTcDCmt394nZBd3x9lSmVncBX7/A/lP/HhzSOJaKwYU8b/v6Oe0KrgpitqPBxgXXMI99FVdtf1l9uweICefdYYv/NBw1J0Ox1yhtBUTAI8lbQc9n1TDSfIEVb0NstrzgP8MAfZpLTPiu83nneviKvHorvlSyoiheHnbf3XbqxuGAfW585LM11dr5CXRv6ozkPDCQHaqYRgYb0OGEdsqOiETaoDrGNF3lSQrpHzz1LVEKRaASknIR9rp4Nxuc4XI2Fd+UkUXZpbl6lFHXhdnU6rCezEine4MO2Y7cjwfgwmag2MgbKeJrvkgOnherGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2SvFJSm6dzdn1l2v3uFDu7bAs1QkUQkQ76Lpn5kD00=;
 b=axjDWwbcjuaF0AU91w2+FUjDaupXcEk8uwpHcdsIF4eiy8t0dMbER+SBg+5PIXYS0DlBnDya+PP3ZQ41HdOgsSR4guclaBIsE9+VR/e7FHJVPL7JMx3zC06dVq/LiMA8eOMlKtJZPSaSTHMYo9H+4RK78qNUm3IBsGaZm1aDJ3benin1ycbej8uHiR6Y/5dWiQHB5/uQlB/3XLyJH+0qI2zLxVDYIwDxpltWuj8IsTfnF7IBGzbUOylIy1rLD2/ekQOd/4gkcGGsIX2uTq7O5urwMZ6Y6Wg+fV+EINR5TGgqX65UL/QI/fqFtZcKHkZQyfVsV3gtp/j13ukPGSnPNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2SvFJSm6dzdn1l2v3uFDu7bAs1QkUQkQ76Lpn5kD00=;
 b=UG7FSszy7rHfaN5S44ryquD9qPaXADt50ZBEHdkeJz8NuOtJ+R8iswx6HMavaKNMLnhWKEYBCYbNcY+FZESMAdhyi9y3lhg+HTvTG7+UWvlYu9USl3vFJOoAdFSqDkgzFA6FGUCg19UodC4fRvY4T/VWasC4oRf3kHGBNDAifz8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4074.namprd15.prod.outlook.com (2603:10b6:303:48::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Fri, 8 May
 2020 07:13:42 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 07:13:42 +0000
Date:   Fri, 8 May 2020 00:13:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v4 2/4] selftests/bpf: move existing common
 networking parts into network_helpers
Message-ID: <20200508071339.wz5zw6s3xoal26yo@kafai-mbp.dhcp.thefacebook.com>
References: <20200507191215.248860-1-sdf@google.com>
 <20200507191215.248860-3-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507191215.248860-3-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2a2) by BY5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:1d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Fri, 8 May 2020 07:13:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:2a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8c8946-8f28-4647-e016-08d7f31f56a6
X-MS-TrafficTypeDiagnostic: MW3PR15MB4074:
X-Microsoft-Antispam-PRVS: <MW3PR15MB40743A72E5BF20A5701C0FF6D5A20@MW3PR15MB4074.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RydDhBPTjEUo0O7pK8Zp0R2kQq+prTSmTahqsbmVyGR+PRhATCEMwFY+sLTLy+2CAmM2uNdQcq2ywRxRKX4ceIg7TxD174QqW4qNp78NUqGEPIC+RmnrGoEKD7Yq4E9DOlI7frT6IyshdSZFC2h7xfEGFdQJE5NvaXgFrGNTBC3qACeG3wpg6AoPnQVTh0/GRwpkCE6qqx2TAf6bBomL3fCGDwq+IQsyJUVneztB8W+xBos8ms+EYazhq59U90Yw+sG+fEQ474EottI6LowZs0aVXV2uIG39M6ST8d7nJXIcZKJvsF5kn/58UixYVZ333owF6iGAlFXHD30UgHI3BD+LMYcMjFkivWEZWsK+Y0BnGkyb3M781C3l2ycTJx0rNJnPjw/t+r/jWgzUgd0QaheikPdVAdPVtofyEZ0QuOHnHUKpM81D3/eX6s/B0Ocn9dJ6ei0t+vCg7I4sSPTwajIY4hYxJfEH+/VlVIWohNA4IkP5P79hrRLV22Fvwg5CQtMClSOwKmJLOAbXpwfasg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(136003)(366004)(39860400002)(33430700001)(52116002)(66946007)(186003)(7696005)(16526019)(2906002)(8936002)(83300400001)(1076003)(8676002)(86362001)(66476007)(9686003)(66556008)(83320400001)(83290400001)(83280400001)(83310400001)(478600001)(4326008)(55016002)(4744005)(316002)(5660300002)(6506007)(6916009)(33440700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eYXDoH4h5jnREqKabEeriiMceaZ5PAMvIGS2VlmOUBTLmTizymGXHzJOEKuRfS6D+6wi3K9iz68twq8oaXnyQgSSDZ9UmZ3A2DAPzwY/PhZ0abQfaldCnH48J/bVW1yDpSFewZamh6BA+Df+R0JxiGIt7Kt5s3uHlxN0pvBz3TMXp7RIS86wdGE+OOEQftIem3FhUeeK0wEB7xZFnAFUiLmwC8kte5Ye9+7T166w5W5GOciD680xehA9XEUXGsUBS1dfHl0AADlzTLdClFcNdUTerL5B6A9NMC5PRRn1V7veU/0E5B/bRok9rpRXuNkOf9ymPm29uuLnio+4pILNXwpd2Kv/1x59LG+uya/vzAJgBCnIg49MxQKMx5wqjX3hcaFgCP4iIKl7WAYBZdb7nKJPD3yZT/HklL/fC7e3+PSqNToBIPHMFUPo48tgi4UWW6ReoAKjkOrwkAFvk7SbCJW5qACXRbijlybtLR4zCVTDegWwv2AX7RK9BVHUXl0Hft6luVn3nowsTkkSLLq8lg==
X-MS-Exchange-CrossTenant-Network-Message-Id: af8c8946-8f28-4647-e016-08d7f31f56a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 07:13:42.1050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwvjgSk2q4MQaqnNsRwxYMbt9MW99oFjuOAlmnp/Wl/NogK4GrWZVmfq76XnoA0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4074
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_08:2020-05-07,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 mlxlogscore=521 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 12:12:13PM -0700, Stanislav Fomichev wrote:
> 1. Move pkt_v4 and pkt_v6 into network_helpers and adjust the users.
> 2. Copy-paste spin_lock_thread into two tests that use it.
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
