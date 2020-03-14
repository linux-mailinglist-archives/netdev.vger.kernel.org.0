Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FED185345
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCNAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:25:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46694 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgCNAZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:25:52 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E0AcaG028086;
        Fri, 13 Mar 2020 17:25:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/N+hQjTMsCymPt+81T3IYCwENGaiqozlUIfMsY7QokY=;
 b=Kxbt0YuLRmQiJa9JNFqEgyl/AvDE1b9TTPe1Huqr/uWUIskwcUtDLsnBD2EJqL2buK81
 iJJwgiDY/SsAAqT0C1yrnEXGU0Q7xLCssjhIQMfnmJxuKX6LCa/g93dK8Tkch+kXd1Zh
 0aXQ+noG7uE4esP0JtyN2Bs65F+oEb99kwA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fq83s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 17:25:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:25:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfID6L5N8vIqupfQwhn5qs64q0MYk1SdLkfu0bC8DZYIfl5e+mXIhlXgzhYyGDclX0PvYg7CTgSw5K8eVCO8szPkXuIQbCgeDF36l7TCJfIGyYI8Ta3BygkSvnvMJAdhdkb2L9+xU0BnPKgnhYoqH5EoUzXY5JAnHm399d1jnThn22qvnrvfGsmyCeuYf8zaiLMJUV4wFYd2dmDxYeICG4OIO6YgeEoZF923y8vr5vWFiitxwFAfOK7YYskSzhvSEiJuAifLVMkqXUKxahos750c2wa47FYKPxMw6XZexNUq+dezAMVWr8wVwMNeP4re89+jMhCj0yTm7ThdJK/oAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/N+hQjTMsCymPt+81T3IYCwENGaiqozlUIfMsY7QokY=;
 b=hyrd8oB9AGSd5rXW8hE+mypL9TmJCknGznVBuLZQukby3UOMKwyMlhFA5nO6fi7ReScFgMqRYrT88DKnFFLo2C/ctZKHqTSvYLFMq6iXXpj8WOLTtsizjGAB5f8tJPoYmVr5i/Un/PcUXvKTIRB9/rnB/tLQ1y1k7PxSONICCg2O4RY9fdmQK7Oz0OhiLsQ0lRX+AwCeyRoASyLzN+vyAKXPGSV634/Xqs4nkGkEGq+eg3d2gx9RVdQnoSLUFxketN/JMD566wabp9P3zk70m1VgI9CZkH/5uvYiv8rAB+kRVvJdTbolh91MStf89F1OMKmaAksuu5BxURdcZogtZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/N+hQjTMsCymPt+81T3IYCwENGaiqozlUIfMsY7QokY=;
 b=VeeFzIluB2X1j4BLmQDCcMdMlhVgvnTcROaDa4lgA7vSMy8WrREQBcG5Zve4mQqZOFG84WlJg0fCXTmmzjSBCS+KBV8xQXRCVgI13/A2Twr347kDaMykt4Au1LERjlWdO3TR0JAEugTk9PhRQNCwzASQ2J1JR/w8T0OqKCo/J3g=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16; Sat, 14 Mar
 2020 00:25:38 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 00:25:38 +0000
Date:   Fri, 13 Mar 2020 17:25:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] selftest/bpf: fix compilation warning in
 sockmap_parse_prog.c
Message-ID: <20200314002535.4sbnislu4ahhgiy6@kafai-mbp>
References: <20200314001834.3727680-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314001834.3727680-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:301:1::16) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR11CA0006.namprd11.prod.outlook.com (2603:10b6:301:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 00:25:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fb9792a-5afd-4898-8464-08d7c7ae3839
X-MS-TrafficTypeDiagnostic: BYAPR15MB4086:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4086A03D9E850AD71336F6BED5FB0@BYAPR15MB4086.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39860400002)(199004)(186003)(16526019)(81166006)(5660300002)(66556008)(66476007)(66946007)(2906002)(8936002)(8676002)(81156014)(6862004)(1076003)(33716001)(52116002)(4326008)(478600001)(86362001)(6636002)(558084003)(316002)(9686003)(55016002)(6496006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB4086;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pn5rQ//RewTFgffavvB7jZQZ/BG5pNdQNbm4oxw7SsiwCdcuE1D7KKhayg3tfAdyXLXUf1BUWTiEoWIqjW5MGMQthD/TgP72q4b+htgXBr5l0BiePnyFJ5hs6BMwZlLJCUhTi+9oqtaob8hmzS/lhA1G2JMtjHNiP69yIxZisi1vFDMXaEd7K+oRs0XwC5GYJ9CSQXjGy2+oLR3Z9l2jncd1M3145LOt8BOLjIZ9t9eL218FCVKTF5j90Ma3R+uaws8GdICfFJyBpCvxxCveB9dd2VIOJL1b0+EoFpJZ38c6b0xnlFkB278itP2wCZyexlgGAPM3eHu5ikDcQvGtXvxZiW2WuExEtWNiLkzguCvy6+oDTs0FsLYVCSx6Twbz0kdsuV8NS+JoX4lIMp0J2rfER+JzfcVVlCLUp30ENWFyeXHuNj6I4FbPW0W+W6rW
X-MS-Exchange-AntiSpam-MessageData: Z16qsIgWJTuvonGvsRXYK8/p52xaLZagxj9HDzeQ+zE/xPhvdoOE0R0eoUgivh4sNlLqM680IJez0kvjGVZvXdlyQklRzMplgCgqUTCtZfIueCF1KOEoGlAElQta6DFYF9TPGqv6YSGPxJ4Trauhw3Z2Ov2qYQUEskcIcscpegrp2AWIO12f6cbb2uXpg0Rh
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb9792a-5afd-4898-8464-08d7c7ae3839
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 00:25:37.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGjbkk6WB4/+9xgoY81Nl1RvUKMxkpU8msFQ/eiO7EfDgUEKTs8IlWCaNwpfnVUM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=592
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003130107
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:18:34PM -0700, Andrii Nakryiko wrote:
> Remove unused len variable, which causes compilation warnings.
Acked-by: Martin KaFai Lau <kafai@fb.com>
