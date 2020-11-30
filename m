Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21092C8E53
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgK3TpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:45:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36446 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbgK3TpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:45:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJcsUq036566;
        Mon, 30 Nov 2020 19:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2cU8DZaDzE1cr1VPUQiF6BAqDQGKq3YIRt7Xa+jowHo=;
 b=EQvSKitQTQ0nbmDJjqDklnoSINMHjmuJph87unCNA6Hos94Y89gSOVO4q9PwaQngrY/T
 0HHqP+ulzzdwVlo56zylpp3gt2xzkuHhimOCZZ+I5c/sBBGrVjrbPWoivNQwS72dm3HF
 xsEx6yOVu0E0gluiMIf/U9Il/3uSP6vV4ydbOrraHkeAulL1vULbN4pY06AGjir6QuL4
 MptfslZAcDNmABZ9iIQdzFxVf36+vEtROJkLm3hIHcVS3+Cnb97WmmfSlPzLBiiCxa3+
 6YJ3NE2zxT5xGlAhsgIP2yp9AxmKeUv/xsCK6VK+nQbGNips3Pq1IhMpLIhw/tm1v/fQ BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2aq4jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:44:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJe2ep149266;
        Mon, 30 Nov 2020 19:44:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540ewywdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:44:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUJiUxD013922;
        Mon, 30 Nov 2020 19:44:31 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:44:30 -0800
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
Date:   Mon, 30 Nov 2020 13:44:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1031 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/20 11:52 AM, Paolo Bonzini wrote:
> On 30/11/20 18:38, Sasha Levin wrote:
>>> I am not aware of any public CI being done _at all_ done on vhost-scsi, by CKI or everyone else.  So autoselection should be done only on subsystems that have very high coverage in CI.
>>
>> Where can I find a testsuite for virtio/vhost? I see one for KVM, but
>> where is the one that the maintainers of virtio/vhost run on patches
>> that come in?
> 
> I don't know of any, especially for vhost-scsi.  MikeC?
> 

Sorry for the late reply on the thread. I was out of the office.

I have never seen a public/open-source vhost-scsi testsuite.

For patch 23 (the one that adds the lun reset support which is built on
patch 22), we can't add it to stable right now if you wanted to, because
it has a bug in it. Michael T, sent the fix:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=b4fffc177fad3c99ee049611a508ca9561bb6871

to Linus today.
