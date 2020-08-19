Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0215D2491D4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHSAbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:31:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgHSAbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:31:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J0NLur019564;
        Tue, 18 Aug 2020 17:30:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=r5u1JfrlgZh/mWV7ndxXDcJhwJ21EYEk5NjlKXuGh14=;
 b=lOuZ/SThM95EooMUFPRpbSlE63umXweQGPHZTKs87mM6fZr9tHZPu5LqgiN4nyGVL8ZB
 wIprePsibCq0XXMfUCH9jFtE1FQTLPcc5KN58qkn+kzE7PfejjGh6gA2jo+N93sI7W5i
 Ws/CjxCQ2AYL1nb5DoWIss5yMKviwAZ9HuY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p7x031-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 17:30:59 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 17:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Butnq2BvCUiXxde2/pJGFC8yCrhnCsr2QT+ayK6q4oqGbs34xB0CyhpPwWWcjPP1j0tHSHv1WijLwno4vfAzch1NQKJ0AjPQLgWix/2qNpQrl4pb4AnKrdjDonzSs7G//CGPkGUC4wSLCqZJlELxOLSP2yVSKxwn81AgEQPluDhRDbkI4HW6/jYp74ZWWJ+YXAmE9vSO1MXOFQDBSOHZ5z/sL2x+4sVGywE7kndoeIfBk9TrCp3MSMHMfruKTnMPXPLWd9typ7d5L42nC+c/GldnmmbC7AbbZqevDPYdI/93fcudenpKktsNiDHZeTkczTp5xTfACef/AFmJ9U448Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5u1JfrlgZh/mWV7ndxXDcJhwJ21EYEk5NjlKXuGh14=;
 b=gsijLuaGUQQRJyHFBLAaTofuQ+8cX6Oi7bzKr0PBHtS6JrSebbNvuZxHo1IX1nY/BJ4E0vPChaHvG8ynHMt8EUh4hy51VIfeW/YTAZdWhg57i9dwYAcT5MdqgrUqWyA0+zLymO6bdZAMYHa/ZgQ23wnHgKqJv2VP8gtd05uRtsO4aU8Ld7ztf6iu7aBdzboAYxzQB+o8bUF+y8FcngkrPvTdYSBrLTts+qjALs53pnuyG9TlAUfIL7BkpnfRE8njGO3r1Y4e0Bys95Hzj8foBGTKSh1Qixs4MLyHBJT//NAaTDm2stI6l6pYXajx+x4r66DMC2wrMQFUF57gAYA4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5u1JfrlgZh/mWV7ndxXDcJhwJ21EYEk5NjlKXuGh14=;
 b=dJpftwz/E7ytT6xuJs/e0b63Ku14ct3MNSwnPGaWIikKkiFweBRG1gbGCl/0Zwctq6qqntVGBeiBTyMmvdGyz41QtuOkwQ2d6wWO7tOtTRBDiBo5YsCepXjIN+iJP19IoCK0zRdjsMSXRzcZVX+6RA0lvY+sE4tdQhcSvIp8WG0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Wed, 19 Aug
 2020 00:30:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 00:30:43 +0000
Subject: Re: [PATCH bpf v2 1/3] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200818222309.2181236-1-yhs@fb.com>
 <20200818222309.2181348-1-yhs@fb.com>
 <20200819000547.7qv32me2fxviwdkx@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac2c7081-8e6b-76c6-e032-ed2be3727e4d@fb.com>
Date:   Tue, 18 Aug 2020 17:30:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819000547.7qv32me2fxviwdkx@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:208:178::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR19CA0015.namprd19.prod.outlook.com (2603:10b6:208:178::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Wed, 19 Aug 2020 00:30:40 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f34a5252-ecc0-4834-7d2e-08d843d71b75
X-MS-TrafficTypeDiagnostic: BYAPR15MB2568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2568B1DA9574875CEA0D71E0D35D0@BYAPR15MB2568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OuFQrkDbeMmahVLHHSuXNKXCiwIT1PwlDyiLRQVnu/MI+5d73uHqSUgq3Ldiwiyizww3/WzOsRLWcIxKRGHJJS/32jyd+RHZzh0xlbvhga2xg2OOTD+Fh9hXuO70EXslMEwpZhE2FmKgSLnCTZSPTH2SPT2b2gC1G9+dOfED3yHWkN2BOiSO0oHE58A+7bZisO+jPrDW23pMU/qJSE7xnZjUQpOV0hLD1j6vyxaxjioL/H9I88/5u+cltkrPZaQ2s5ndSWC/dZuvtkQ1QEFNIwSwHpouUrIU+2xmckU/mkOvaTcH40AH1WVI5MAmmiJDQgfOO6cDKtuaz22iri8hMvqNh2UlELXD42Pywq38bkR9KvfesjyLg1+jaF/QY9Ig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(136003)(366004)(52116002)(8676002)(478600001)(6666004)(6916009)(2616005)(83380400001)(4326008)(316002)(31686004)(6486002)(16526019)(8936002)(186003)(53546011)(86362001)(5660300002)(31696002)(2906002)(66476007)(54906003)(66556008)(66946007)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cOmauN2IFA0kKuLLSe0O2/QuArd86oVWTukQKpc+aTXBLO/VzWdvLYE/KDqsNrd0p7gzJ49f34bSUfMAnGBx2srynt+7jGLJ8Lz96AJU/Tubv0JBDWOfZzVMsek2n1VA64dbllH4cGAgkNlXbXFC8d3dJcjvbg2JNfyu56zJ2Mk1B72qxUWKecZAOG+ACMgjTwDnMaWFrRRLvK977qGRF0wVcHymF9uvvBwk3eJNqzfZ1hkBsVrZcs5BCCOeo88LuYSZsPjzHERkm+CWSJach+VEbTJJpkPxJDN8QhFswDEoYsmJ3fNAMfyM4T6qbvNpv40PTm9rfIAqrOuE9jIOTXpe686xNo7FIgLgjDgjEkMRNGGrhpMUP72cFj/uKMcwA+WIQU/AxBC7Wbv+Hc32j0j8hk7Bthyh7BXguIUIc69jjfFIamGogS6lzPrsINxjXbwUcYIbbMFhTg8e+xQR2FaI12cNRXPDbdNMyYah9qzkqbF5ix3Bxl7pU+RxN+Dwzf878cuTPUkSRzaziElflJI+1d5JBZdNaQYiuQQbgvN3Pv+gB/A4pDGFVXL+6qWZxYKtMiZZNlChMfVSoc4Uoy7C8IO7wPCWUO/pCuMSwFPDL/Cbmcsz6nYN/NiddbEXNiqrn7Ku+d+u83wdebxgN966WF+U3o3gdpPom7PUSkB0aqG1/coKNjMql9xUpnun
X-MS-Exchange-CrossTenant-Network-Message-Id: f34a5252-ecc0-4834-7d2e-08d843d71b75
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 00:30:43.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6HLdehmR1Ef6G4zOd54UMAsbbSaTvn3x8XFZv3he55+FpmIkbI4Zy/isT38ieHJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008190002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 5:05 PM, Alexei Starovoitov wrote:
> On Tue, Aug 18, 2020 at 03:23:09PM -0700, Yonghong Song wrote:
>>
>> We did not use cond_resched() since for some iterators, e.g.,
>> netlink iterator, where rcu read_lock critical section spans between
>> consecutive seq_ops->next(), which makes impossible to do cond_resched()
>> in the key while loop of function bpf_seq_read().
> 
> but after this patch we can, right?

We can do cond_resched() after seq->op->stop(). See more below.

> 
>>   
>> +/* maximum visited objects before bailing out */
>> +#define MAX_ITER_OBJECTS	1000000
>> +
>>   /* bpf_seq_read, a customized and simpler version for bpf iterator.
>>    * no_llseek is assumed for this file.
>>    * The following are differences from seq_read():
>> @@ -79,7 +82,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>   {
>>   	struct seq_file *seq = file->private_data;
>>   	size_t n, offs, copied = 0;
>> -	int err = 0;
>> +	int err = 0, num_objs = 0;
>>   	void *p;
>>   
>>   	mutex_lock(&seq->lock);
>> @@ -135,6 +138,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>   	while (1) {
>>   		loff_t pos = seq->index;
>>   
>> +		num_objs++;
>>   		offs = seq->count;
>>   		p = seq->op->next(seq, p, &seq->index);
>>   		if (pos == seq->index) {
>> @@ -153,6 +157,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>   		if (seq->count >= size)
>>   			break;
>>   
>> +		if (num_objs >= MAX_ITER_OBJECTS) {
>> +			if (offs == 0) {
>> +				err = -EAGAIN;
>> +				seq->op->stop(seq, p);
>> +				goto done;
>> +			}
>> +			break;
>> +		}
>> +
> 
> should this block be after op->show() and error processing?
> Otherwise bpf_iter_inc_seq_num() will be incorrectly incremented?

The purpose of op->next() is to calculate the "next" object position,
stored in the seq private data. So for next read() syscall, start()
will try to fetch the data based on the info in seq private data.

This is true for conditions "if (seq->count >= size) break"
in the above so next op->start() can try to locate the correct
object. The same is for this -EAGAIN thing.

> 
>>   		err = seq->op->show(seq, p);
>>   		if (err > 0) {
>>   			bpf_iter_dec_seq_num(seq);
> 
> After op->stop() we can do cond_resched() in all cases,
> since rhashtable walk does rcu_unlock in stop() callback, right?

Yes, we can. I am thinking since we return to user space,
cond_resched() might not be needed since returning to user space
will trigger some kind of scheduling. This patch fixed
the rcu stall issue. But if my understanding is incorrect,
I am happy to add cond_reched().

> I think copy_to_user() and mutex_unlock() don't do cond_resched()
> equivalent work.
> 
