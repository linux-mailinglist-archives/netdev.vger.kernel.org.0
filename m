Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B393027CB56
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbgI2M0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:26:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgI2Ldb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBPP35191277;
        Tue, 29 Sep 2020 11:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Q9XFzQq1ftNd/6nhZwM6OK6igXtWaspUnrZOg4CnAdc=;
 b=WwiMDiujMHZi+Q02nHSZamBamqnCFy26N0CgCXrHQ9265qMvZW/t7VWkbiNnSCK4RPmN
 xw0cF0PftzA/L0X3RXtZdOBqF5pT7cm8LZUDFpb/g62Vdt+7Cl0TqhDqQsebMclFN9I6
 jG81QNhrwDsenDafdVF29LA2OTTlG08Xv1komJoRmsTnZuEgR+2wsmyCBd1e27JXD1nF
 HVo8jxhepx2MFVWpX2F/ZFUEKi5UyRP3GeIkiVh2fv8nPLQnh9DLMR31xd9yrnyr9vU7
 NNicpawhp23xJCxLAPjBqa+/dM9VkpuusB1bpWsZoX/W3jFUrlisBmZtLce28SEQixZ3 Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9n23jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 11:33:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBTiHT052060;
        Tue, 29 Sep 2020 11:33:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfjwj5ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 11:33:12 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08TBXBwP028097;
        Tue, 29 Sep 2020 11:33:11 GMT
Received: from localhost.uk.oracle.com (/10.175.172.184) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 29 Sep 2020 04:32:42 -0700
MIME-Version: 1.0
Message-ID: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com>
Date:   Tue, 29 Sep 2020 04:32:29 -0700 (PDT)
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/2] selftests/bpf: BTF-based kernel data display
 fixes
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolve issues in bpf selftests introduced with BTF-based kernel data
display selftests; these are

- a warning introduced in snprintf_btf.c; and
- compilation failures with old kernels vmlinux.h

Alan Maguire (2):
  selftests/bpf: fix unused-result warning in snprintf_btf.c
  selftests/bpf: ensure snprintf_btf/bpf_iter tests compatibility with
    old vmlinux.h

 .../selftests/bpf/prog_tests/snprintf_btf.c        |  2 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h       | 23 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_ptr.h        | 27 ++++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        |  2 +-
 4 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_ptr.h

-- 
1.8.3.1

