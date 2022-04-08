Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B9F4F9293
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 12:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiDHKLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 06:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiDHKL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 06:11:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27F83BA50;
        Fri,  8 Apr 2022 03:09:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2387HFUj021343;
        Fri, 8 Apr 2022 10:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T5Atx+7kTedvnEDpEIC0njDhjhAzWDlGwxFTzMGcAMI=;
 b=U/iT9jOHI4G6cRsnN27S+BiSdqkdbjXaJAqSTTjgIRxa5BhGH3meuym8no3q6stRkUYD
 W+G8ZtDfj0oqF2ngHJfJmulkS8to52J+sdMKsBjCduVooK8a3lfbjSGq5Lm6c0WV5KCh
 tCcrLCDW35wdEuV2BwAgBf3A0fFq52rp/8wiVPhKLO40mHFwPiY1QDi8vzvj36LzYRC8
 IyerPlR036izohSu0UBJye90UyKzvlLXqa8yCVx43kWLnl4fB9+HIKw3pHyAwLn/bf05
 8uj066BSdNVWSL/KvjVdaD+TdXoMMV/H/bRp70aPNIdsJ4wjq2pPmMNZnV1ZFfl1Z/o5 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fa4jx0bsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 10:08:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 238A8cFH011216;
        Fri, 8 Apr 2022 10:08:38 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fa4jx0brx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 10:08:38 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 238A7fCT012964;
        Fri, 8 Apr 2022 10:08:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3f6e491f9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 10:08:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 238A8YlS37552460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Apr 2022 10:08:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 232F0AE055;
        Fri,  8 Apr 2022 10:08:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FEADAE04D;
        Fri,  8 Apr 2022 10:08:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Apr 2022 10:08:33 +0000 (GMT)
Date:   Fri, 8 Apr 2022 12:08:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Message-ID: <20220408120831.69b80310@p-imbrenda>
In-Reply-To: <16491AB0-7FFD-40F5-A331-65B68F548A3B@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
        <YkU+ADIeWACbgFNA@infradead.org>
        <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
        <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
        <YkvqtvNFtzDNkEhy@infradead.org>
        <482D450C-9006-4979-8736-A9F1B47246E4@fb.com>
        <16491AB0-7FFD-40F5-A331-65B68F548A3B@fb.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t3hK8XhpLSnjlRE4B--CvrO_I9pr8wKT
X-Proofpoint-ORIG-GUID: FUuQ-w1NOoS59KRH-H9GhuaqTGwB2CY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_03,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0 mlxlogscore=954
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 19:57:25 +0000
Song Liu <songliubraving@fb.com> wrote:

> Hi Nicholas and Claudio, 
> 
> > On Apr 5, 2022, at 4:54 PM, Song Liu <songliubraving@fb.com> wrote:
> >   
> >> On Apr 5, 2022, at 12:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> 
> >> On Fri, Apr 01, 2022 at 10:22:00PM +0000, Song Liu wrote:  
> >>>>> Please fix the underlying issues instead of papering over them and
> >>>>> creating a huge maintainance burden for others.  
> >>> 
> >>> After reading the code a little more, I wonder what would be best strategy. 
> >>> IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
> >>> For example, all the module_alloc cannot work with huge pages at the moment.
> >>> And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
> >>> powerpc with 5.17 kernel as-is? (trace attached below) 
> >>> 
> >>> Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
> >>> However, given there are so many users of vmalloc, vzalloc, etc., we 
> >>> probably do need a flag for the user to opt-in? 
> >>> 
> >>> Does this make sense? Any recommendations are really appreciated.   
> >> 
> >> I think there is multiple aspects here:
> >> 
> >> - if we think that the kernel is not ready for hugepage backed vmalloc
> >>  in general we need to disable it in powerpc for now.  
> > 
> > Nicholas and Claudio, 
> > 
> > What do you think about the status of hugepage backed vmalloc on powerpc? 
> > I found module_alloc and kvm_s390_pv_alloc_vm() opt-out of huge pages.
> > But I am not aware of users that benefit from huge pages (except vfs hash,
> > which was mentioned in 8abddd968a30). Does an opt-in flag (instead of 
> > current opt-out flag, VM_NO_HUGE_VMAP) make sense to you?   
> 
> Could you please share your comments on this? Specifically, does it make 
> sense to replace VM_NO_HUGE_VMAP with an opt-in flag? If we think current
> opt-out flag is better approach, what would be the best practice to find 
> all the cases to opt-out?

An opt in flag would surely make sense, and it would be more backwards
compatible with existing code. That way each user can decide whether to
fix the code to allow for hugepages, if possible at all. For example,
the case you mentioned for s390 (kvm_s390_pv_alloc_vm) would not be
fixable, because of a hardware limitation (the whole area _must_ be
mapped with 4k pages)

If the consensus were to keep the current opt-put, then I guess each
user would have to check each usage of vmalloc and similar, and see if
anything breaks. To be honest, I think an opt-out would only be
possible after having the opt-in for a (long) while, when most users
would have fixed their code.

In short, I fully support opt-in.

> 
> Thanks,
> Song
> 
> 
> > Thanks,
> > Song
> >   
> >> - if we think even in the longer run only some users can cope with
> >>  hugepage backed vmalloc we need to turn it into an opt-in in
> >>  general and not just for x86
> >> - there still to appear various unresolved underlying x86 specific
> >>  issues that need to be fixed either way  
> >   
> 

