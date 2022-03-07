Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB8A4CEFDC
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiCGC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCGC6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:58:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C83AA7C;
        Sun,  6 Mar 2022 18:57:23 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 226Nvjef021551;
        Mon, 7 Mar 2022 02:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1eIJSI1NTmItcs+yInRgSiDCvd4xmWyeej3JLoJid00=;
 b=jv8VDTxl4rByADG0VXUaLiX5/iEzdPz1RlCujzZ/1HHtQbwAUFy/KLa2YZnE0JKTG3It
 p/zc4ax4K9T7eCskvNPvlc2i+S/zU+tRjwqUMo93yHDwE9+9yprZfbp20ZmQ+maIdFIz
 4Nx9FlBZ0JaoquPLPryktNUrhG6gQHwYChm5mDnBaO2whlRWdz8KGv0fMBN+Y+EmOvN4
 x+1XxhaFJmFp38ur8KX/k3etJKskATqTU6c8YzRmx/gSw+eImDnt1y+JENDadaabYXXR
 Qla3MKtoTfJ9jKJeSImz1kOKu+l5Now6x3PGP0vnCdeURbn3R52Fv7tSngNH7YdPzEgf 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3emsauugyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 02:56:37 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2272rjs1027309;
        Mon, 7 Mar 2022 02:56:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3emsauugy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 02:56:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2272oglG020550;
        Mon, 7 Mar 2022 02:56:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ekyg8udmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 02:56:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2272uWlE54985058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 02:56:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF4335204E;
        Mon,  7 Mar 2022 02:56:31 +0000 (GMT)
Received: from sig-9-65-93-47.ibm.com (unknown [9.65.93.47])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AA16752052;
        Mon,  7 Mar 2022 02:56:29 +0000 (GMT)
Message-ID: <40db9f74fd3c9c7b660e3a203c5a6eda08736d5b.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     KP Singh <kpsingh@kernel.org>,
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
Date:   Sun, 06 Mar 2022 21:56:29 -0500
In-Reply-To: <CAADnVQKfh3Z1DXJ3PEjFheQWEDFOKQjuyx+pkvqe6MXEmo7YHQ@mail.gmail.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
         <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
         <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
         <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
         <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
         <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
         <CAADnVQKfh3Z1DXJ3PEjFheQWEDFOKQjuyx+pkvqe6MXEmo7YHQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1i1lsDYxbujpiuUY5lO0IzHm1pdBsxDU
X-Proofpoint-ORIG-GUID: 9Vu05vBnzLx42nhBLQjdsKV_lX1PuNqU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070013
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-03 at 14:39 -0800, Alexei Starovoitov wrote:

> . There is no such thing as "eBPF modules". There are BPF programs.
> They cannot be signed the same way as kernel modules.
> We've been working on providing a way to sign them for more
> than a year now. That work is still ongoing.
> 
> . IMA cannot be used for integrity check of BPF programs for the same
> reasons why kernel module like signing cannot be used.

I assume the issue isn't where the signature is stored (e.g. appended,
xattr), but of calculating the hash.  Where is the discussion taking
place?   Are there any summaries of what has been discussed?

FYI, IMA isn't limited to measuring files.  Support was added for
buffer measurements (e.g kexec boot command line, certificates) and
measuring kernel critical data (e.g. SELinux in memory policy & state,
device mapper).

thanks,

Mimi

