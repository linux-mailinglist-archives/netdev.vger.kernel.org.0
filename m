Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF44D08C3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbiCGUqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240590AbiCGUqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:46:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA8B8879C;
        Mon,  7 Mar 2022 12:45:23 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227J1sPw013154;
        Mon, 7 Mar 2022 20:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=OvvbqIC3KMF+Mdr3mDTTZDBVVM+/GzPwzpmF1cYD4sY=;
 b=Jegmh+1SVZdcNidD3Xt766p2MsxjDSwzcuZzJFrRhk7h/fbVz/TKBgta9cCkxwEd97Zy
 fwl+tX0dxGbNBrk7qngU9eTTfGdK+4Kiw/UOYVNheBWZDgGJ7WkysC/wT48pTJ09TB9m
 +l66O67/9qeic1/+mJJOy1NvtuFRXlTK0NIC55tKNNHz5yfp6mFXjkNsKz0Rp/FvQoxM
 YLPwUbUNPxUxexxDIh1N0O7qefRqzmDehULXbmJ8cHtbBBwFAgLA3IwC5NsSElB1hHpL
 ynfJDH2fcC/9j+eM2pZSseXmeR0RzR++XybjQLGUse/qz3NlNH2nHLgAKSiOA+v/cRIp XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3enq44tk6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:45:00 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227KXcpp019002;
        Mon, 7 Mar 2022 20:44:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3enq44tk63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:44:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227Khscl002401;
        Mon, 7 Mar 2022 20:44:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ekyg8wj1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:44:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227Kis2n42991942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 20:44:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C789CA4059;
        Mon,  7 Mar 2022 20:44:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7ADAA4051;
        Mon,  7 Mar 2022 20:44:51 +0000 (GMT)
Received: from sig-9-65-67-225.ibm.com (unknown [9.65.67.225])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 20:44:51 +0000 (GMT)
Message-ID: <6d8ebebd5f3518f4bc7e68d2b04be5f2bf5a2d08.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Mon, 07 Mar 2022 15:44:51 -0500
In-Reply-To: <CACYkzJ65D2OZKrEbrCS32+FsQ3BVzs1zQcRQSLnaNQHYTjZFBA@mail.gmail.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
         <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
         <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
         <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
         <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
         <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
         <CAADnVQKfh3Z1DXJ3PEjFheQWEDFOKQjuyx+pkvqe6MXEmo7YHQ@mail.gmail.com>
         <40db9f74fd3c9c7b660e3a203c5a6eda08736d5b.camel@linux.ibm.com>
         <CACYkzJ65D2OZKrEbrCS32+FsQ3BVzs1zQcRQSLnaNQHYTjZFBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rDF9aAWglsWGovclxFWDSC9yIdvasWWf
X-Proofpoint-ORIG-GUID: p_yzEHuWyVcE4cN6DfhUcZ1PzrDc1BOK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_11,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-07 at 14:17 +0100, KP Singh wrote:
> On Mon, Mar 7, 2022 at 3:57 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Thu, 2022-03-03 at 14:39 -0800, Alexei Starovoitov wrote:
> >
> > > . There is no such thing as "eBPF modules". There are BPF programs.
> > > They cannot be signed the same way as kernel modules.
> > > We've been working on providing a way to sign them for more
> > > than a year now. That work is still ongoing.
> > >
> > > . IMA cannot be used for integrity check of BPF programs for the same
> > > reasons why kernel module like signing cannot be used.
> >
> > I assume the issue isn't where the signature is stored (e.g. appended,
> > xattr), but of calculating the hash.  Where is the discussion taking
> 
> This has the relevant background: https://lwn.net/Articles/853489/

Thanks, Jon!

> 
> We had some more discussions in one of our BSC meeting:
> 
> https://github.com/ebpf-io/bsc/blob/master/minutes.md
> 
> and we expect the discussions to continue over conferences this year
>  (e.g. LSF/MM/BPF, Linux Plumbers). As I mentioned on another thread
> we don't have to wait for conferences and we can discuss this in the BPF
> office hours. Please feel free to add an agenda at:
> 
> https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=0
> 
> (best is to give some notice so that interested folks can join).

Right, but probably a good idea to understand the issues at least at a
high level, before a meeting.

> 
> > place?   Are there any summaries of what has been discussed?
> >
> > FYI, IMA isn't limited to measuring files.  Support was added for
> > buffer measurements (e.g kexec boot command line, certificates) and
> > measuring kernel critical data (e.g. SELinux in memory policy & state,
> > device mapper).
> 
> Nice. I need to look at how this is implemented.

ima_measure_critical_data() is of kernel state info, so signature
verification is currently not needed or supported, only measurement.

thanks,

Mimi

