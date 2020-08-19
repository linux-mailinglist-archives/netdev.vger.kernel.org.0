Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFE24A7FB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHSUuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:50:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgHSUuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:50:51 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07JKoWA4032198;
        Wed, 19 Aug 2020 13:50:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H+RpGadKkwjqQ+BQ/hzmedK4h6N9n7V029jfwP7guo0=;
 b=buCAMz8nXUyHGcMFrWizWB4Sjn6N/E9paZMetFQ7TN9RL7XUrs/SGf+StUdwOzhN0TiM
 3XapZ5wuzVp1CWBlEKUsf8668XpJD8NC9nI7Vub3ioDVzqrqfC8R92+dIzHzO0xGgCno
 2tTleyvmqw4HKhn4UkgzMWaWE4+VAhjc0wA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3304jqakrh-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 13:50:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 13:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTWk4E8M7JaapqkNKHitMpYwQ44XI2Gl0XIY0ud96ZxvTxlEL13rxtD5pnEuCCZHbULlxSiKxnWF8r5ZyO6DTMxqJ3H2CYG7mvCq9PJeFERUxcwYLjuROBS1GbhGrF46+gB4V48A9kXptMNvP91uQTHMWKJFZ/1R2TGGSF4riRSKb4+bQcm5+uSFe94KfXSit4PDXDmZR6GSrfKRw0CYIuRk/nVO+37La7LM7npuzw3H6H+XQenLTkcOeCWN6YqxG/Ad0XJZFpYJ42LeoMoGwIl6M1lWB7nEuUlqVts/hFMscMwB4XAWAXiOKrtcaxYf0C8he1M25M6dwidLZLlYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+RpGadKkwjqQ+BQ/hzmedK4h6N9n7V029jfwP7guo0=;
 b=UEZLG7jH/b/vs67yc/c4ubj+N11aC/7hvzqNmLel117hm/sN71auWV1hBciZzbVjPxASUImniJ02+7zlfhwbgkbI6l6/LIMKlohMsMNfmkAHRhKscxONWi3eIKCuXgLTrRUDYUEf9ek/h3LCVQB/+4u68z1LamukIrnJ+2hQwYhlJbXi9DWMrcPl+fyCTCU4krDpQpyq+Yp+yfqzXYDBczqdHcgDn/vMYnXymPPuLwXqqtLNBJiXx40hK9qX2YNVa4S96iI4IrPuv//CxsCdL2n1mu1uyQPf26GZuMTEZnElULc7WsmX+H3QWElNu+HXBBOwD/cyTEzu0GaJOhe0uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+RpGadKkwjqQ+BQ/hzmedK4h6N9n7V029jfwP7guo0=;
 b=KaunacxMp0q+OFYHqxtJeAjcZOhAe4mFghQoOxbs242uLmaY2eduirA9GQJrFmFOzXvXmN0ug1h9p3UmViQGlBfOzwTSVp++3VOCL6WcWjntMvz00i1GRty8YMdCYX3y0CbCT0+lwby99UZzIy7TaSPSjdLbb6Hqg3i1xMdW2No=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 20:50:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 20:50:41 +0000
Subject: Re: [PATCH bpf] bpf: refer to struct xdp_md in user space comments
To:     Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20200819192723.838228-1-kuba@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <931cca2a-60af-71f5-aac5-a4651db0fcae@fb.com>
Date:   Wed, 19 Aug 2020 13:50:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819192723.838228-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0048.prod.exchangelabs.com
 (2603:10b6:208:25::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by BL0PR0102CA0048.prod.exchangelabs.com (2603:10b6:208:25::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 20:50:40 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 545d2bed-e61c-4436-8761-08d844818920
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2376FFC7A8702E7E410150AED35D0@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8tHdlUJeRO51X5ZK2VNOFyTPdpg6jUWbvVWWH0x61us+om+99E34SNpKHNtyJdePsYoJylLmsEnTndFJ2YnIcQfy+zC4Fs8DCtHWOpmJTujUtXoF1TDFZhPMlbrkE8XDpnGu7G5CpIpf8cBf7JdtZphxoatAkxb9KchAXZnlRtzaztdY9kBMY4Pd+XonAbX9x7//DtZ2M/bDI3IDuvcuukwSUQ7e0voQ+sQNXAcsDy8qzlDaRhR7GlkZ/uB0KYRgHUCtrLGwcIci6N1z8w2bRRGaNjCNS0gq+tYi3SvfT49TzT6A+rkKW9YC2CpRgYUMxFnilqi1VCbn2hr52xG1mJluPz6aN8kYppbX10WZj8pNV4vPZFrJboKrrJE/7WLa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(396003)(376002)(136003)(16526019)(31686004)(52116002)(36756003)(4326008)(6486002)(2616005)(86362001)(31696002)(5660300002)(186003)(316002)(2906002)(66476007)(478600001)(66556008)(8676002)(66946007)(8936002)(558084003)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9PFHH6jmkBCOnCYlrck5/eGuN3iTmKSI2QH3gCQvtCekxnB+G9mmwRReJwzWyGvkyY8XjsgnhFiBgnLwpKoIoTFUFeqAXLbCaIoO2+gLCJQMBoYZ1bIfvA8YfMr6PLSsPWwzSeYoh8NpBCVF+XSgRXwn0giboTvePk/ih6AJvA3vj0ISZtR1Ivh2PStjbY/8kwFtbQPLGRrq642wD9sTru/LTdkgU+PdRt0p5beN7KELDJDIaRbtzkSijlKtKW9uibbqQYe66YfrV7rViTMZiDqDL8ZrUFp6ETb/XKCMlk1MENum6OKPQl0pMo/lmpZd4dhuJncyhDF7FJZQM9z/l/z7JTP1ksEm6lFuQW4d0Xqu3nuXyLx+UuPaUAeoksBjjlcpHUj+e7Ccd5XqSQ2z0AH/vUUVMT/cB7DoQ8/JhDpkTlm48DkGQCAzDDQjNCb8Ul2FpnvbEM3OqMFT8GEDayymAl5ZuY/lP3YLSaGKehjrm4vJPXVFj2w/H54EAwVZ1e3g3IPqw8UNG7R0M6Dt53LEg0sumpxdgcmW0MQ4COLgdvgjUumVlD+jFb6Mxjj0yGLDqh41me/YaASAb4hBNbjPz9Wwtvlk79J96HgVlvrUeTxtf5umsngxhfeBarTemPP0Qcti2FVvNVFu9sIby243hV7piTGWwAnvYs3tNMiF17UfZLTg+iSr4MgT/07K
X-MS-Exchange-CrossTenant-Network-Message-Id: 545d2bed-e61c-4436-8761-08d844818920
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 20:50:41.6864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hibp2aNSSivzO2H+XDioR756pAQ0RNEEFyaCZJwYhsWa3uWm3vr89btQfEueHBN5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 12:27 PM, Jakub Kicinski wrote:
> uAPI uses xdp_md, not xdp_buff. Fix comments.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
