Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366B91CC6D3
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 06:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgEJEsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 00:48:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56170 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgEJEsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 00:48:08 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04A4ei4Y029523;
        Sat, 9 May 2020 21:47:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+lSoEr3X5Nca/sYDaPtWEvfZjp+Dk5wltglt4wI2UfI=;
 b=U+N5P0MiZTOoAas4udQcHMnSJ/IskQq7lK3mM7O1HbtGIKx0E7aQHn/9fIqu/v/qOqcJ
 ZJ+Q6EMasFZ0+m48dQHxyaWLUL428ZLEQJAWL44TbjnFnRQDa8q+KnxQya3bEGGXckET
 Fv9rIR93BjID3pLvJ8wEhQTRbwTCPGQQ8ME= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt8su05x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 21:47:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 21:47:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQCaFNwUkx5ILz4UI1KwxTv544BwKB3ARp0Px7eIMhdtkWCmRBRVF0bAfyxBwHRtHoyzsg8pTWstoVGdiVCgSYHFqI0uKGRCdlapkKwmyD2Bdmiw07cX/DpijWDZZIyzM2B1LEYFjnZUd5JsGsLzUYj/GL+634Oz3TrgPyrHNzCoaTLI8MAS4i21hAkbqoHVzktmkRkoKLyU48Qb7lZZckn4g57wcSbLSd+Kpa9QdNvmCldir+t1twa3Zof/mUczNx8YdU2xR5L+rXRfsdibq9aSIiVgtqChir0MjEw5S6HqH1mx27cbbz9PGVgEoR3UJCL3q7PjNw2ISdDPEnhedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lSoEr3X5Nca/sYDaPtWEvfZjp+Dk5wltglt4wI2UfI=;
 b=behAm+y4TYafvi7CnsOZC1yK+5tbCec8Kk3rqWWZy64lxLW9IhIsU7gLBWClXqAjgYNan3vyqLVKmE/JunK2L3M81M4avL7SQ9+xoyNJ1B4rH4pTktfvjwgkqhV8l9613x59oAJkj+br9HwlXMV6NHihSCbXiL+TJO2CvsSZRreEE1xSRoAxuI+TGq2RHCcg2wVYis0HocjTg0l03oB6GZHhXPqn8BEIXk/wnfZEGKeBFTcRq8czGGQksOToZjevYPbF3IdXkxjnhluvqN/xtrTRfdV0O1omQj94EUl7lpWE1VEVcfrAtb+Y5regWi4kg59TFmBfRhn22SwWKgcIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lSoEr3X5Nca/sYDaPtWEvfZjp+Dk5wltglt4wI2UfI=;
 b=RqtFpMG4LxZU6U7B0K7MFSw9L4hmnM0/ujvo234VSBaXRLQecDQBhddGsrJvoO0pWWIZZ1/nN9Giu6bqLusBUpLaOZs/jqCkcXINCaEFc1FeffaFmocgEJteKLbyX0Tagr89Kf2oStjrTLqvEyJBxzp2LBPKvrPJ/FSgKyuFjBc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2565.namprd15.prod.outlook.com (2603:10b6:a03:14f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sun, 10 May
 2020 04:47:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 04:47:50 +0000
Subject: Re: [PATCH bpf-next v4 00/21] bpf: implement bpf iterator for kernel
 data
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200510002731.ztx2inlfs65x2izc@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dbf925da-c0ff-5772-83b4-77ab88f29ca2@fb.com>
Date:   Sat, 9 May 2020 21:47:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510002731.ztx2inlfs65x2izc@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::48) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BY5PR16CA0035.namprd16.prod.outlook.com (2603:10b6:a03:1a0::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sun, 10 May 2020 04:47:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca0822a3-1166-4d4a-c840-08d7f49d4a90
X-MS-TrafficTypeDiagnostic: BYAPR15MB2565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25659A1A08E3244147EECDE4D3A00@BYAPR15MB2565.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ut1iesgTHj/Zms0gcYSUMAoCzYKiuwPI58X8gXjds2sxsNk14K28zOSJ4/Ffb1Lx31RfhM2+7jArexcUWJHp1he42Uepbz1cRL7Jili02rGeVclrcxowtSrwVrg+5kA+XGtdgxtXHpTfP2oD+5RDXtnBf2OUndqz+kfx8jFMaTPx6w9MFQ2KEc8xWWNdMJWJt7hmKiK2ItFLPBq8l0DpKPZi8DikwMv9A/0KAYBaZ+oTrkxsuNmnUrvYIel/F+zbhDY33PwT+Z10KcqRtBijrR0BbMP3ExgwKh2HVfHiBeaapC1yMJl23BV0+9qNHsaPFGnAVG7W5SX+7t8mA8NbqSCTw9WwYwEhvifPAqly0OClvYDV3GbU781D4hjM6RlHpmKSQSsxHs7uq/JMaeW4bfoPKHm9yQS3c9T1WqFz8U1BdYFWwNyty+33pVxt8O1dRNI3KYcul0cVbEt1u5caeKA7YeAqGfm+m9mzSnWkZt831K9qplBkg7z3J7IIVQVkdIrKgd+MQxj4Kr+29EikbtN6eKYa4xCxrdWDO8R870cPFIaTXYS9gCQndfJQp8+Zw4QzR0XpIAI/Po6Mg3RkrySQJLcv0AfLiOFCylJ0IlnwVgIuF6d6Jlcdz0S27EjMVaqfWbZxM8KxW+hhU17ncg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(376002)(39860400002)(396003)(346002)(33430700001)(6512007)(8936002)(5660300002)(8676002)(33440700001)(31696002)(4326008)(2616005)(54906003)(186003)(52116002)(6486002)(316002)(16526019)(478600001)(966005)(31686004)(66556008)(66476007)(66946007)(2906002)(6916009)(86362001)(36756003)(6506007)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: r4j6sebPZDh51vRzpqV0rSZ6a8ssu1oXHjFsEZU6YC3O9KzzhVTN8x8ZADNtqqR8fC6bmHftrE7Go9kHhGjkFbZMf5HVicuZrRDCJYUfHx9gGHrDOrpzzpADszK0K4Alazecy7jGnaib915VnfQfWikQIACYYODCEipsE96B6D+dNXoOVIzW8/oHVeq7MNpirnQujzC4yE2svljy9SL6LuuRxo9PmzUuV1cx4/hT9W8EA3IWOyA6o9441VM1q8NYexikXvPirhW5qeVp7EDNlFqs/mdkCJxQYBBze3RKS5VGBGQ1JPEWYvE6fTFlEdniYmCwa1WKHEn28TnO50LQcVuIcT75RDkPQS7a2BSvOF4tiJLupZGBltsMoRw51ics7wcRcDYSDgKL4cuIDFxsNWnOFLgoYIFsCBhwZT0ZGm/a8Ab4QArNUQlw5G0sYsCwcyUJM1xxmq3JxafB6PFrUuXTpN3JYrKJgBP8kBKXuH6Yz4rt2m26xu2aHGNHHn8icH7jpLkk+/hV2yA3eMdPEw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0822a3-1166-4d4a-c840-08d7f49d4a90
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 04:47:49.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/Uamqo7X4Q8RGkCDAOZswzw/JfW3zrWvrLPGWFnrTWw+VDkIBS1db9MS/D/BfHB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005100042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:27 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:58:59AM -0700, Yonghong Song wrote:
>>
>> Changelog:
>>    v3 -> v4:
>>      - in bpf_seq_read(), if start() failed with an error, return that
>>        error to user space (Andrii)
>>      - in bpf_seq_printf(), if reading kernel memory failed for
>>        %s and %p{i,I}{4,6}, set buffer to empty string or address 0.
>>        Documented this behavior in uapi header (Andrii)
>>      - fix a few error handling issues for bpftool (Andrii)
>>      - A few other minor fixes and cosmetic changes.
> 
> Looks great overall. Applied.
> But few follow ups are necessary.
> 
> The main gotcha is that new tests need llvm with the fix
> https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D78466&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=bCI_s36swhyaNaGGr3YQ0eQH9Lc-hpSGQy3u9fCRL9A&s=FLMd73HYbmZPnZrtCE9ntzg9e9eHOCioQbrt1w4sgWU&e= .
> I think it was applied to llvm 10 branch already,
> but please add selftests/bpf/README.rst and mention
> that above llvm commit is necessary to successfully pass the tests.
> Also mention the verifier error that folks will see when llvm is buggy.

Okay. Will have a followup patch for this.

> 
> Few other nits I noticed in relevant patches.
> 
