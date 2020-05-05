Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE181C621D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEEUeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:34:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10218 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbgEEUeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:34:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045KTPau006608;
        Tue, 5 May 2020 13:33:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bfr5+dvSyQ7Vt9vVldubNDb6SMVce+BY4GHJaT8G6AQ=;
 b=roCUB0ZS9Nszfz+hZh1g29ESTehOkZzdHOoTM6++2+M6+Labn7RnNe+9cpbnLjem6uD6
 SCwFifDQfOgYk1sksEIg4G5OAhEeexr145qzgeOYZzdWgBMS/dhWKXcbVZB6vIhZ6ZvL
 WU8ZieL1FrGQsp5YC7Vi0WnwlaN9DP5DE6U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmrmc5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 13:33:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 13:33:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoXP5muuc+7FcLego+7v9cBmYyqMj8moioukzofM0qQDXoa3ZAglyaKzMZs3eWJUEZf/xl8I8PsCPGOEyV111dXIbizc0a7M9ol/M7RY4/h8Az3/e4ob1uSn40ytjgxAfh+AHS3+K0matTw0/K+TRwSZkiAW/4/fRweAAc/AFNnRaqlmvUv78XdS5+WJUWA5iY0wEXmBS8lHfv4bhvnbKbCsXTiHFrEYsxPNpmpjPLKAkDW+k2LsnSLby9wast/LmcmsGDjom98rOl9SGpFmENDesjVFDCrSjkuwffTayi0ckWuTMt2mRmh/6z3VpTRPH3AEE6D5GVKMbRv92YOzQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfr5+dvSyQ7Vt9vVldubNDb6SMVce+BY4GHJaT8G6AQ=;
 b=f47gA9xSHlqmnvtYKgnhkAo/oriMseKAgkcFM5CTQDMUqlam//SoI5kwHPAAzsoD5Js4n5QKmqrKyMVIDMXSKEcA3ysFsK+SCaIYw67R8HGXLRCYRAsGOsYqOM43NCrZsO7Mkj1XXN/tkaGBr/BUtJc6nN2idQbEH3ZVgsDUwV5i+PnkY+g2YecPka1eWD1WEy5GlR7KoIxycBXWaFkAGRLQdf/hziG7ooHZAcaWIWmRxiDLPtN6zDw79BID1pGHHEb+oXnLrH6QJu0Llu2+Y46Xrd4UnJai1/n91vYYkojliJ4LCuidjf4ipRVtsRAgbLUdWa+zKY695aLnuZ6wLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfr5+dvSyQ7Vt9vVldubNDb6SMVce+BY4GHJaT8G6AQ=;
 b=UyRvDxcPaeraGdC6capjaGfnapI6qG5j8ADPykNcPZ+fDDdJjOMCvjDzYz6MMbm/2vTqCQcm2sAxn19YUuaBTvw92u/viENb16sYP2payu77sccy9OvpefpBy9I+cHgCtrvMj2mevOoCiqef1/lErKMEhi1Gex5dz03IezxMhd4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2261.namprd15.prod.outlook.com (2603:10b6:a02:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 20:33:52 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:33:52 +0000
Date:   Tue, 5 May 2020 13:33:50 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: allow any port in bpf_bind helper
Message-ID: <20200505203350.GA65096@rdna-mbp.dhcp.thefacebook.com>
References: <20200505202730.70489-1-sdf@google.com>
 <20200505202730.70489-5-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505202730.70489-5-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BY5PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::33) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:d580) by BY5PR17CA0020.namprd17.prod.outlook.com (2603:10b6:a03:1b8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 20:33:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:d580]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa17018c-394a-42dd-e2b0-08d7f1339f8b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2261:
X-Microsoft-Antispam-PRVS: <BYAPR15MB22616B06AD77C3B2134FEBF4A8A70@BYAPR15MB2261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jmzr5apqJECCIsE6AEnihMCNQs9i0JAd5IFBLoPsmxiDuPZ7HG5LtSEJpkBdWaZGfbfnW7Adjm7JzZe+qDiLbrp1oZO0kGmNlCvWbr86tBWmmdP1LefpE4K8JD1ZAQZKH2uVhCMmsmCC+LdyzrbAcOYSVFgUxIcMZpsCxROCDEMZHpDB0QdsMTpYd0KP0N86Ms8wZ7xszJ+Nf0IqJhZgSP1+IdJ02lLTlP/V9EZUI8J7lBvpiqJtE6fBd4wd8uGJrKn9Srmcq/xCZGDHzrnfChNGvnMUBHeJakiHsePOwtfgeIom7P+aIlN4Up/uEW5bTBJik5M+m/YDSIqTOC8s2jp0VTsLj6PbvfJ30FOl/lGPKk8JPWaqTfOLGaTkmq8WaK3RTCmEF/RQP8aQcoGSA6xWpHq4jy1fu2kOmR/RL919y5NWYNvy7CUBSvecBZiC4jlWSMeaBd//4fjT/og+g2wc0BOGjv6liTXP13MWk86IhyYMKL6s4B2S62L+xB4+seMqhnPCYzeU6ZxgFYupnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(376002)(366004)(346002)(136003)(33430700001)(9686003)(5660300002)(6486002)(1076003)(16526019)(33656002)(186003)(8676002)(33440700001)(2906002)(6496006)(6916009)(8936002)(52116002)(86362001)(478600001)(66946007)(4326008)(316002)(4744005)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Zeu0a6kshgWYzdPmuHUO6dIoe5BYXZtCPEsmnD260T4GwHsQXzVu6+91PTZDRsgv/UmB9BKQCFc9pVuk5eyENK+aJtX5yoarAkJ10dnqGmL81w+sPmkAtmHN5xEjUQGulqIBo7T5hKfZzj4oK38doJPebOCoVq9LpzT/3jkbJnxVZmqid7PizJw2O4VUooJWEqnFUfCk5QVXfqxIQ33azEvb+QZKSCRLS4wYIp7sMXn6i6Liad+uIzHKXo0NyO1SQ1K4eTQsf5Tp0ltGsWquPtsYXBtJsGkBWnIYwyxfBWqY+JHizn8BajA9QJsKzkw0vXHKvNXtYLL4gMhFcc2nGBQWsl8zSARbG/DHAIwO6cM7qkcDjnYpV4JD9uwD3NGZ6xrrFANEIyBlUqLnW3hcDtzh2R0GSwXhpaWJ6RVKX/ixIEOBFTPrzDBDp4plD+zawOHZl/C/sXp3Sf831UxEcadwEi6mOuvlxhwz5Z84fbNdZBM+jUJthqftGXtkvDiZdHFtZOdkXm3Y1/wg+4PAsoa9P4jY2eDbIprBbjLy4XNUdcwcZFmnkRA1W1vuk+QVDovGZrIO+eP+KftwuzvTETwGfSnRNE/6PjrtAobXBjB2hXV8zwUKRV0rkNfQyReZ3bR1WlsTnfJxpcM8HTGLq8NGuR7DcrMjsjXr2E0fU27h8Cgc16t00nf5InKmJ/mGvc5I+V575OgENRx6OS5wxt4tZYIpDzTqOAQjkhpwopjqWsyc7UflILjHRBJ4QjgjN0OjO4g5y0v3HlXlYpFXs7zg4d+a5rROliqUcqSO/h/sX4F6QwQ0wJDJ3wDAyxcY6/nynxEnigiNWwMVol+8jQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: aa17018c-394a-42dd-e2b0-08d7f1339f8b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 20:33:51.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76l/rjsHZs1nX7bdWWlKDlNSDH9Oc+b6qsrbG5YEBo88PpNpXyld7XFHYib0CAkn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=879 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005050158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Tue, 2020-05-05 13:27 -0700]:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive. The expensive part
> comes from the fact that we now need to call inet_csk_get_port()
> that verifies that the port is not used and allocates an entry
> in the hash table for it.
> 
> Since we can't rely on "snum || !bind_address_no_port" to prevent
> us from calling POST_BIND hook anymore, let's add another bind flag
> to indicate that the call site is BPF program.
> 
> v2:
> * Update documentation (Andrey Ignatov)
> * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Thanks. LGMT. 

Acked-by: Andrey Ignatov <rdna@fb.com>

-- 
Andrey Ignatov
