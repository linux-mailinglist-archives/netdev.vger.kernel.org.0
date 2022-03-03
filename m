Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCAE4CC5C9
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiCCTOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiCCTOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:14:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C268E15695C;
        Thu,  3 Mar 2022 11:13:53 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223I7lah022075;
        Thu, 3 Mar 2022 19:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=qmrt+/Jkb8gDsrGOIzxJnNKsZAsWE6WMeHS3jtGFsOw=;
 b=DiSJgUgqV7yXSBLAk+0HzVrG7I4/t/D2mCttumHpFScW6oS0jrkN3NDg3d9cyNoePadv
 54tzw9Vlm+QqZwcrckbjN9EDRMh5eSnRSobU2uYLLdkCe32o88YAkgtyrUdjQTa73kZV
 wzN0th04iOw9EqF7PaAEeCuFZz22nu+Cfe8BRkLUuM7yjg0+kmaZqZt89qF1l+Clg+yh
 67Q7bpkJ7pQb9O5WF/ce/ne9l1X1OxHW/MALb9hgxpfEx2IttLwc5vqfR7S/tdJ4vvh4
 +6BS/QKQZu/dyQ1NKXSscwI9/JR5NVxOd3fcRX8xKmwEwaQQxZFehTlR7VyW1gwM0ZCB rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek0nm4asy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 19:13:32 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223IdA7Z019088;
        Thu, 3 Mar 2022 19:13:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek0nm4ase-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 19:13:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223J8wax004102;
        Thu, 3 Mar 2022 19:13:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3efbu9h0wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 19:13:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223JDRHq41877958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 19:13:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4232A42049;
        Thu,  3 Mar 2022 19:13:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD84B42047;
        Thu,  3 Mar 2022 19:13:24 +0000 (GMT)
Received: from sig-9-65-93-208.ibm.com (unknown [9.65.93.208])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 19:13:24 +0000 (GMT)
Message-ID: <b6bf8463c1b370a5b5c9987ae1312fd930d36785.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, revest@chromium.org, gregkh@linuxfoundation.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 03 Mar 2022 14:13:24 -0500
In-Reply-To: <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
         <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
         <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com>
         <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
         <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FANeqy5G1wiM_J_SJU3GjaSTTFkeGmlg
X-Proofpoint-GUID: Ur-wuaMT2dDIoAnuan4VD-noqUb6Frs_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 bulkscore=0 mlxlogscore=995 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-03 at 19:14 +0100, KP Singh wrote:
> 
> Even Robert's use case is to implement IMA policies in BPF this is still
> fundamentally different from IMA doing integrity measurement for BPF
> and blocking this patch-set on the latter does not seem rational and
> I don't see how implementing integrity for BPF would avoid your
> concerns.

eBPF modules are an entire class of files currently not being measured,
audited, or appraised.  This is an integrity gap that needs to be
closed.  The purpose would be to at least measure and verify the
integrity of the eBPF module that is going to be used in lieu of
traditional IMA.

-- 
thanks,

Mimi

