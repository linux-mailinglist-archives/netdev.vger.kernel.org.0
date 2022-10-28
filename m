Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FBC61124A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJ1NGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiJ1NGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:06:14 -0400
X-Greylist: delayed 1379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Oct 2022 06:05:44 PDT
Received: from ma1-aaemail-dr-lapp02.apple.com (ma1-aaemail-dr-lapp02.apple.com [17.171.2.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431201C77C0;
        Fri, 28 Oct 2022 06:05:43 -0700 (PDT)
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 29S9u46C016057;
        Fri, 28 Oct 2022 02:58:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 cc : to; s=20180706; bh=Xjc094u+AENYAy780wiOIS7Vu4csTEusafewG04ZfLk=;
 b=rGfIzaEiP9tADaTvuOLfYE2pgsuMC5cb+qiwBMdkZgjTDgVgxbNy1g0fN3wkyMpgYUTl
 /heKsKdnMoq6dT9A0qmUtPOtVJ09yi7YIRYeANjAbZGN0qf9i1VY+/QeE5iz/v0ZM3Q0
 6AmU3TrLKY7TBl+jHYBec1SCDnpcz2NxRrAxl9Uslo3SJkYJbjKepq7fJZVs/Ols4SgN
 pDHSCmF29wJUSkM5FqkmfOxmzM+GmZve/4fQBVQb0yCMrCaTAOklCeYKBYyQ6ICyZJal
 1PASLN/1vvZET+9GQgA1m5dnQizczpM1kwYrCssOAefGXXyJ/3a6+wOaSuekDa4DDDEL Ww== 
Received: from sg-mailsvcp-mta-lapp04.asia.apple.com (sg-mailsvcp-mta-lapp04.asia.apple.com [17.84.67.72])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 3kfareubhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 28 Oct 2022 02:58:06 -0700
Received: from sg-mailsvcp-mmp-lapp03.asia.apple.com
 (sg-mailsvcp-mmp-lapp03.asia.apple.com [17.84.71.203])
 by sg-mailsvcp-mta-lapp04.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.19.20220711 64bit (built Jul 11
 2022))
 with ESMTPS id <0RKG00WGEJOSD500@sg-mailsvcp-mta-lapp04.asia.apple.com>; Fri,
 28 Oct 2022 17:58:04 +0800 (+08)
Received: from process_milters-daemon.sg-mailsvcp-mmp-lapp03.asia.apple.com by
 sg-mailsvcp-mmp-lapp03.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.19.20220711 64bit (built Jul 11
 2022)) id <0RKG00700J9FQ700@sg-mailsvcp-mmp-lapp03.asia.apple.com>; Fri,
 28 Oct 2022 17:58:04 +0800 (+08)
X-Va-A: 
X-Va-T-CD: f0a22bb548ee5a27b547ffb857e18dd9
X-Va-E-CD: c97f448c63d97b3cfb2d969c8ae164a2
X-Va-R-CD: 93ae6d4824a01f2bf1a497fa17aabd03
X-Va-CD: 0
X-Va-ID: c6ad71e9-3350-45ad-a0c1-eb8893672283
X-V-A:  
X-V-T-CD: f0a22bb548ee5a27b547ffb857e18dd9
X-V-E-CD: c97f448c63d97b3cfb2d969c8ae164a2
X-V-R-CD: 93ae6d4824a01f2bf1a497fa17aabd03
X-V-CD: 0
X-V-ID: 2a6940f2-5a7b-4957-803b-fa54b013e3a3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.545,18.0.895
 definitions=2022-10-28_04:2022-10-26,2022-10-28 signatures=0
Received: from smtpclient.apple (unknown [17.235.153.88])
 by sg-mailsvcp-mmp-lapp03.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.19.20220711 64bit (built Jul 11
 2022))
 with ESMTPSA id <0RKG00XG1JOO9F00@sg-mailsvcp-mmp-lapp03.asia.apple.com>; Fri,
 28 Oct 2022 17:58:03 +0800 (+08)
From:   Vee Khee Wong <veekhee@apple.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Message-id: <A23A7058-5598-46EB-8007-C401ADC33149@apple.com>
Date:   Fri, 28 Oct 2022 17:57:49 +0800
Cc:     alexandre.torgue@foss.st.com, davem@davemloft.net,
        edumazet@google.com, hong.aun.looi@intel.com, joabreu@synopsys.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, muhammad.husaini.zulkifli@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, peppe.cavallaro@st.com,
        tee.min.tan@intel.com, weifeng.voon@intel.com,
        yi.fang.gan@intel.com, yoong.siang.song@intel.com
To:     michael.wei.hong.sit@intel.com
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.545,18.0.895
 definitions=2022-10-28_04:2022-10-26,2022-10-28 signatures=0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What is the purpose of this patch?

The function definition looks exactly the same as =
=E2=80=98tgl_sgmii_phy0_data=E2=80=99.


Regards,
Vee Khee=
