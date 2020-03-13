Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5EA184D77
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCMRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:21:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbgCMRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:21:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHB8AR017144;
        Fri, 13 Mar 2020 10:21:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QkKWp6YFHo90VhAeGFG4KdgDdnsZRXB4QDMlHXYGTfQ=;
 b=mg2G6wWcXMKUaMdGzJm5KlDr8s4ZNL89+REYV+66/306PK/py33q3Q7KXAUR2CQulzmY
 ahxdQIXqCm9va/PK4e6L9W3lwtUzbA1PKKltawdn4zuOLWAjASkhnTjHmY91ym9BZFWf
 UQGqBKXmHFGyPpb4zva4X91E7HLGrs4FjTU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7t59cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 10:21:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iD6w6buFlsmcrIX6tlPdug96xbcgQlcB2FibwOnAmVdBfcaPoWqU46swf1fr+FLJZyI3Kclf5gtcRpquuS11U1QQjlIBzd++32rwZIAOajLmB+luawE+Z+6YX5V9hVOPqavMIDdpcLf76aZP+wzI8nzTBxFT9NZq/Y/z/GN8APH6YGHT0ipKv3O0KQbei3jWJhDT5VlYCt9YmNH/MNHQ9PfPKKcCyuzm1eYBFaMrjlrFKVja4NmMoM37v1uP8ti1W6dPBTcdYEDCeUTvIIklPLZ/PvfVUbhCJLQ1UBZANc/YFUzHiCjQv+USnqN4TOUBM99IflQZTKAVM0V8Vz4eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkKWp6YFHo90VhAeGFG4KdgDdnsZRXB4QDMlHXYGTfQ=;
 b=Vk5ibgT2KzljOVlRrja17FG3ZmvyUan+e99428KzwTMJHJclDTtTd7Jio/GIXjbapTxnWSaVlhnsLyg4BEFbK2cwQ6LVpVn8YM3lrL7GcFMnjY+2U3Jo55Xo6R10WZ0yBNupW3Fd3AgslXEg/Cx2bvhUsTuPU4bO4RI4aM3oE6UK/53ZRfTgyNeT+yx5Zcrw7g79RaiU6mS/rHBdED83kQAj3V+9U1fD88PWtspXZQn5Ez/EjMnCktBhGQFbeHwreRBDrDSzXlPg44l8xkJ0gFOb7uZk/d8+q/0Y+GtPy38MiNas0B/qsQZfua1Xz7djMTeO8fV7PnHf2lnuNWSTgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkKWp6YFHo90VhAeGFG4KdgDdnsZRXB4QDMlHXYGTfQ=;
 b=A0MdMCFlzxmjvvM95mwuAEqgxApt4CE2vDFjxRvLEIbYrP+dA3l9R/BxNsZdHgTKB7K8WCOufy8ZBJR1uh4rdGM5fiCwSSv/JjI9NrQZ+P3a0UnQkNYt9LnwxhuA4I1yXFSI12cC/AjBiMxt6CW5Ovg5n9BfWI5inW2/u3UwhuM=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3080.namprd15.prod.outlook.com (2603:10b6:a03:ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 17:21:21 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 17:21:21 +0000
Date:   Fri, 13 Mar 2020 10:21:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>
CC:     <netdev@vger.kernel.org>, <yhs@fb.com>, <quentin@isovalent.com>,
        <ebiederm@xmission.com>, <brouer@redhat.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf_helpers_doc.py: Fix warning when compiling
 bpftool.
Message-ID: <20200313172119.3vflwxlbikvqdcqh@kafai-mbp>
References: <20200313154650.13366-1-cneirabustos@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313154650.13366-1-cneirabustos@gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR18CA0043.namprd18.prod.outlook.com
 (2603:10b6:104:2::11) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by CO2PR18CA0043.namprd18.prod.outlook.com (2603:10b6:104:2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Fri, 13 Mar 2020 17:21:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4efb1587-1f65-4e29-b79e-08d7c772f319
X-MS-TrafficTypeDiagnostic: BYAPR15MB3080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3080F4470D84300BC4CD7A5DD5FA0@BYAPR15MB3080.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(39860400002)(366004)(136003)(199004)(1076003)(52116002)(186003)(2906002)(6916009)(66946007)(66556008)(4744005)(8676002)(66476007)(16526019)(86362001)(5660300002)(4326008)(6496006)(33716001)(8936002)(316002)(478600001)(55016002)(81156014)(9686003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3080;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oSwgTFd99WoUnLpyMIB5xPQemmK38igL30T+uXsPtD2z6g8n1QBciA+RIr61/JxNrcPvp+k03XTsC0UtVNhhnlGLHSJJT2hxlC/+KMEMWRu+iwrIYp9CWgPpEpvdHOhuWY17ukghuj2lW8VjyQcgua5oyNS6sx1YaOfxzm5po0X66Ai9Xn7DfHC8VRSS6iM+JOOP7ZlmcWab5i8gw56t6MrXQhKimxFXEeksGjHD4V4kMnqT8RwF/dUkRmLyP9wvteG7uiF6D28+V2VrCsgg330mQjT7L0d8duvddIWVYkey1pvWYWSxE7UOr1XK3r8YKVeWbYD99icUNQNFsf3hZO471WahDfU21aXWd42Pyxgn6Cok6mN4xDlfYkrn9Z03nVzzON8uutD4c4adYh/6ZcDmKlFc1lhgDZZfMm9aSpfg6pvuarECYAHx48w5S0zv
X-MS-Exchange-AntiSpam-MessageData: ifM1bmUlK0eXJIC0MzZkgH+nzuPnMBzNo5emsbmx9JzsXZPqxqPZun1U9q1qaq9zBjgWH2Vx350FJgQ1pNOrfLTXDbD9ZpOrJrvQjPasSh1gB25IBF3X0ULXwBjdszE279axCVNwMGMy79ze6Y6RtuiAZhnilQTMQKNFecWskUsx8e0FgY4/KW40t3o2hNR+
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efb1587-1f65-4e29-b79e-08d7c772f319
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 17:21:21.7780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/kcQbt15jcvBaF7uKLYbyc4JBRMwG9F3Mr5WnrzcT4bYlmKax2EVgTOTOjn5Xnd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3080
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=732
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 12:46:50PM -0300, Carlos Neira wrote:
> 
> When compiling bpftool the following warning is found: 
> "declaration of 'struct bpf_pidns_info' will not be visible outside of this function."
> This patch adds struct bpf_pidns_info to type_fwds array to fix this.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
Fixes: b4490c5c4e02 ("bpf: Added new helper bpf_get_ns_current_pid_tgid")
Acked-by: Martin KaFai Lau <kafai@fb.com>

Please add the Fixes tag next time.  Other than tracking,
it will be easier for review purpose also.
