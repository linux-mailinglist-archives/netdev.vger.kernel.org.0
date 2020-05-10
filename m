Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527971CC6D5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 06:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgEJEvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 00:51:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgEJEvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 00:51:46 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04A4oESb011486;
        Sat, 9 May 2020 21:51:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Vs1lD4HSkD+yTAEITliiWEDk40+NoPAzjERTBscxrjA=;
 b=Bur5We4tFGIATieyosSKQAkASQReY1E1YKfp8CGPAqShC4XEPmaJWqD3jyWc8LRcIDPE
 /dPIjQKjLnl6dMgP+sr+NcNQeecCmYg8IGPRnT68BHlwBydJUSAcOeHAGpcTKOQElSy1
 KfQz30E9j0brbwvmjHyB6T+1PcT903zHg3g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt78k0qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 21:51:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 21:51:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv9LdGnIfwbRazsNZb2b4epLgap8PEng/76xKccvWSaZGmbxyZ6AfTAmX3n5KAoduqyueCMV7eMGCreYBcRS5KMLDuS8O88RcGHwLycFSPtaxXe3fd9K66NJZs1V9Ebh1Y04N5bc1HzYcI/6SrqYMS+OCsfdB4y8OZmSqg8livZe3/kVLAM79KqnqumI3BwSvfM08GVruTg81YqsHMwrKje6DIeIbeEiCMooxZTitCJZOxINFc8b/9LWSYCXzti+pDCXtCdMCAkT2d75HXULSdkYIiCk41Xcbww51XlPE+oG/Tj9LCYKA4FZDgnjN1q22AuBFpadymrgWfffIG0Njg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs1lD4HSkD+yTAEITliiWEDk40+NoPAzjERTBscxrjA=;
 b=YxdeD9YVVXgioEfz3iys68tSMAt6iysaCbZiQydJUTRu+GfDeyqq1Gd4DQtofez4XvDI6rdi060M+pWX2BdGhDc7y6GxTr/sQd9j+NhS+Sd/bQ+/mB3sqGSktSN3ojiyrAGE0+yoe2qtB4I/vUBRWguwv9jaZPjeNxvwZGyuKSsUierooKG4LAmnKld9zjXCwKHU2HNG1+2EkE3LC5jerdOD/OG4XzdNhu9yssgDmPXVl4O+XgjaoJQdpb8t2/9Fet6PF6leRYw7H6vRDIVEp+EVUswn0iV2JJMFJPtd60iNjTWMjFbPjyqyL7Qwtq7iu6oQe5N9xx3W+v62IMP/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs1lD4HSkD+yTAEITliiWEDk40+NoPAzjERTBscxrjA=;
 b=Aqng+Pn0E0fDt/TXWlmkRBo0FEmmeo795OG5MsQHj5GYo0ak72LDA/IrLkC4LB57Rn0y6jr6g/FNmiLUqAIDONI8+MwY1qFSD/GsB0HgL/y6Q2Yd33xe+rXe7yZH2K8Oi2ZnzSW+1XAI2TcBY60rG3i8pHcLEGkHC3MpyfUjkbU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sun, 10 May
 2020 04:51:17 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 04:51:17 +0000
Subject: Re: [PATCH bpf-next v4 05/21] bpf: implement bpf_seq_read() for bpf
 iterator
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175904.2475468-1-yhs@fb.com>
 <20200510003036.3xzunae5nd75ckc2@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6cca36ce-2f8e-e5a4-4e80-f838f7f543fd@fb.com>
Date:   Sat, 9 May 2020 21:51:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510003036.3xzunae5nd75ckc2@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BYAPR02CA0010.namprd02.prod.outlook.com (2603:10b6:a02:ee::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sun, 10 May 2020 04:51:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a2c72c3-cbfc-494b-3d12-08d7f49dc621
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28224DADDA913641F471137FD3A00@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GiRrcOcH/rxdhy5GVf80qFmqyc6R+azsamkaOkL+DsfsOicBREq2c1oYhJGcWqp4wkiEQm2+VsT1p/rzZpIChrw3jIjDfEZE3m9cT+nqYlH7gzauOFnhacTpyJ05P/8GQ2nv+120NGzrdtPwmgJB28AjWVbBIgm1H0eYhjnGMiU4TmIKaWzzD79/j6m1zdG1p1HhSTp+KVojCB7iEayUammKzyl3h8CFvq+gS3Z1+VXeL2O8dbOLomj0tj6ORGDBKx6f437jQvbtzNsE7ov9nUh2G3SX4s80B4MTCUxomkq1AM4FFl4ikWHiJyjXulbdCyVS0i+3JOjabiuSaNXfUtc4LaNh4OGFohIhk1Qa4Nb7ZlT/LzkEutDk0tbnP7wt9Ycq8Ez7Qo+bCzMAJRcfoDmHQevVgbPMZ2r58uZLsyGa0RpqHT+lu7CWoSWh8Hl4DltvPBlMKVxnk5BYF3cMjEtsZlynmDJEjAINKts320g2DIGnT0bMl91oFSvUxAIMbLuyxqrIqvuAsz9bFH++LF4/TIz8CsD9jRLHVT9q4QZdPjQsFM/p8v2hy1DIMWoS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(376002)(396003)(136003)(366004)(33430700001)(6506007)(31696002)(186003)(53546011)(2616005)(31686004)(16526019)(52116002)(478600001)(4744005)(36756003)(2906002)(5660300002)(4326008)(8936002)(316002)(6486002)(6512007)(33440700001)(8676002)(6916009)(54906003)(66946007)(66476007)(86362001)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0J874dPQcLh7LoeRERxONue0h1p4FZ/nF6MVdVzeX/f8DrNgqTGDloPpnG3kcOQltuMmDC/lJmqGw/0LNcm5U83hgbKCyrI6bloWlQSi17AJXPI3qMyZAbySBKb4h4cC6FmkmdXrSNS87xsc8SbCXKPT9nrRUABU7Q2vzZ2oJ7hrOmE3NdSGV1IB/nBfH7tKz2McKjExQPs1HZrsfnf8mghCap09sbO+qEUZZNLZv2JsVvoKmsNYIDgm1O8clLslROhnGJPg4nx2hzoepCF5k9YBh2osa2vOGnKR8o2vGZMMgoHybhW4RFmDZhzjpPgUrkB6yieTUXJ8MWQ7gp0kVNcCdfEJ93dk/ryMCahEOPWLqTf/hn5Ij+uOVI8UrZgqANMrGPmudwUHBo/FD2FCoFhGJee1FcDxPMrriChEmaamNiwiQtS9b5rU0Zv/RKbDyWWlSeppF8naDvZSp7EDqlABon8gtrmYkkIrKesu3KRE/Lj4/KB3rqt7KjlW2bWPtz9LF5+Pfqx7gs2TvGftWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2c72c3-cbfc-494b-3d12-08d7f49dc621
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 04:51:17.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tQI8snaLqpUlCbxJWq7q5WXXZ4o7LGaNStT7vOYx3oZxn/rhYZpkcEvAU1M+oAQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=862 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005100044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:30 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:04AM -0700, Yonghong Song wrote:
>> +
>> +		err = seq->op->show(seq, p);
>> +		if (err > 0) {
>> +			seq->count = offs;
> 
> as far as I can see this condition can never happen.
> I understand that seq_read() has this logic, but four iterators
> implemented don't exercise this path.
> I guess it's ok to keep it, but may be add warn_once so we notice
> when things change?

Yes, it won't happen with our current bpf return values.
I keep it to be compatible with seq_read() and for potential
future use in case we want to enable this.
we will add a warn_once here.
