Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0824925C853
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgICR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727786AbgICR7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:59:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083HWnHs176888;
        Thu, 3 Sep 2020 13:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : from : subject
 : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=83xresj1d5Yam9UmN2HklPzJ1iyLjqmtWsgci2yFXwE=;
 b=a6zmMVnJwoL8OPzwG4iJBmXU2o3rCXXhe7BpNmvKGOhEY9O1D0hGQfwhWq2FidUId+LN
 wjCWyIln6n2z9dKSN1jPOoIpCbEqAzUf3/VCaK9VUkUMlYA2dsgaQAm1ST5Krixmqncj
 SBZUO1ptVVhXfIYtEMg5INvoW/RNqxwclm5ltRXO8IFFr7CiqPWaDeTaLa3SJ1AsSKwS
 23W+xCEEA/RmACriHfZlBRFH7Gla28+/NWytodAXJ7hDpO19fQ0LpoGbbmasdAwVjxzV
 YNSJbwYFb0hP1hJq4EtM7KOQEWkejT0v88ZjIQv0a2+fa3Yy+9SsPsGKYqUm7h40zyPn yw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b4gv1ff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:59:49 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083Hw06m007685;
        Thu, 3 Sep 2020 17:59:48 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 339tmvbx2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 17:59:48 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083Hxhhm36110688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 17:59:43 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA17A6A04F;
        Thu,  3 Sep 2020 17:59:46 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641F36A047;
        Thu,  3 Sep 2020 17:59:46 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.240.157])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 17:59:46 +0000 (GMT)
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: Exposing device ACL setting through devlink
Message-ID: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
Date:   Thu, 3 Sep 2020 12:59:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_10:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=1 mlxlogscore=516
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM VNIC devices to administrators through devlink (originally through sysfs files, but that was rejected in favor of devlink). Could you give any tips on how you might go about doing this?

Thanks,
Tom

