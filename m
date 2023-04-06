Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983446D998E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbjDFO1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbjDFO1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:27:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91278A51;
        Thu,  6 Apr 2023 07:27:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 336ENmVI020995;
        Thu, 6 Apr 2023 14:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=saoNYOqPt6VsUojW/8hu5QJoZP9SkAgaLjDxZIVXA+s=;
 b=XXaq3+fNlFJuvL0GVb0lcWcV6rghnUHD9X2A3E0kfQa1VwsyDBe7UOHP9bEmcJpn/zyD
 b6LdzvO6IS8GNtNw+tpkTkphgaV38L+wgResC4AfglHKMd8gErZOL5YGPDdZO25A81L0
 HQDlF0NkYjZl26SDGW3EDs55w/dKyHyPB/fZnXwnrfHJf7mN/GF4043vvfeYA11zHAXb
 N30Z0MHJgsjEfH6rW41rJGRHTuj1gW34ue3FVqdHaM/X93711zCeOiUQDQ+wJNgTuJZQ
 Q18bzACPCVQbQ36eKZxYud0s79XD1c/FZN3/encUGJHQjghA7Aao0+WOExqlabvvWZ2p eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3psyt4g33g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 14:27:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 336EOvcN027398;
        Thu, 6 Apr 2023 14:27:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3psyt4g328-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 14:27:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3365Oipk011741;
        Thu, 6 Apr 2023 14:27:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg4crk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 14:27:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 336ERUNs46203558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Apr 2023 14:27:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BD920043;
        Thu,  6 Apr 2023 14:27:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E66720040;
        Thu,  6 Apr 2023 14:27:29 +0000 (GMT)
Received: from [9.171.94.198] (unknown [9.171.94.198])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  6 Apr 2023 14:27:29 +0000 (GMT)
Message-ID: <5a678df91455e29f296de25ef4aee25cae0e23d6.camel@linux.ibm.com>
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 06 Apr 2023 16:27:29 +0200
In-Reply-To: <33ab688e-88c9-d950-be66-f0f79774ff6c@linux.ibm.com>
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
         <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
         <33ab688e-88c9-d950-be66-f0f79774ff6c@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RP2eKKtkhRnK8pgor1LkMEOxnoyGgopa
X-Proofpoint-ORIG-GUID: 8domNh6sBjZaYrrIUoGXlsF_8qSI8bE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_07,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=890 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304060124
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-06 at 13:14 +0200, Alexandra Winter wrote:
>=20
> On 05.04.23 19:04, Niklas Schnelle wrote:
> > One more question though, what about the SEID why does that have to be
> > fixed and at least partially match what ISM devices use? I think I'm
> > missing some SMC protocol/design detail here. I'm guessing this would
> > require a protocol change?
> >=20
> > Thanks,
> > Niklas
>=20
> Niklas,
> in the initial SMC CLC handshake the client and server exchange the SEID =
(one per peer system)
> and up to 8 proposals for SMC-D interfaces.
> Wen's current proposal assumes that smc-d loopback can be one of these 8 =
proposed interfaces,
> iiuc. So on s390 the proposal can contain ISM devices and a smc-d loopbac=
k device at the same time.
> If one of the peers is e.g. an older Linux version, it will just ignore t=
he loopback-device
> in the list (Don't find a match for CHID 0xFFFF) and use an ISM interface=
 for SMC-D if possible.
> Therefor it is important that the SEID is used in the same way as it is t=
oday in the handshake.
>=20
> If we decide for some reason (virtio-ism open issues?) that a protocol ch=
ange/extension is
> required/wanted, then it is a new game and we can come up with new identi=
fiers, but we may
> lose compatibility to backlevel systems.
>=20
> Alexandra

Ok that makes sense to me. I was looking at the code in patch 4 of this
series and there it looks to me like SMC-D loopback as implemented
would always use the newly added SMCD_DEFAULT_V2_SEID might have
misread it though. From your description I think that would be wrong,
if a SEID is defined as on s390 it should use that SEID in the CLC for
all SMC variants. Similarly on other architectures it should use the
same SEID for SMC-D as for SMC-R, right? Also with partially match I
was actually wrong the SMCD_DEFAULT_V2_SEID.seid_string starts with
"IBM-DEF-ISMSEID=E2=80=A6" while on s390's existing ISM we use "IBM-SYSZ-
ISMSEID=E2=80=A6" so if SMC-D loopback correctly uses the shared SEID on s3=
90
we can already only get GID.DMB collisions only on the same mainframe.

Thanks,
Niklas
