Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14B7163652
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgBRWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:45:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgBRWpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 17:45:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01IMh21k010556;
        Tue, 18 Feb 2020 22:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LgtDhGcMicnQ/HovtsUZ7ZcsAV2e19NUsPDAG+k2uj4=;
 b=Sjfd0R37h393Osv6xDwgLNRVrXIAiZXBlIpq9PyyKU0wqm8Gnx47kjm+exCxEeRQOg9E
 MvIQryiP/wqUFn6ozgD+SfMddUD+UJ9vNwhbcWNDJ9yb3/CmVGEM8GZHoO6ZiXuPmzYb
 RpiInH/ZaPicRzvZCFDwNoHPDqmPNm3FALmJsH8osYIZTOm9uzy9bBd6GitJU737NUHL
 SZtLOYZqubJBkzSsCuBPoA7HS1H7BCddTyomDsp0PmO2vaKFIhxzBSOl88I+3lJV/meZ
 S0dCWlmw1ykBHuS2+mbwAPgDHuytM0YwtccABb8Z2kWePxomirqIJiIPrxXim/Vrqz4v FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y7aq5vm50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 22:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01IMhanx085598;
        Tue, 18 Feb 2020 22:45:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y6tc38mkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 22:45:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01IMjd79016522;
        Tue, 18 Feb 2020 22:45:39 GMT
Received: from [10.76.182.202] (/10.76.182.202)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 14:45:39 -0800
To:     sgarzare@redhat.com
Cc:     stefanha@redhat.com, netdev@vger.kernel.org
From:   ted.h.kim@oracle.com
Subject: vsock CID questions
Organization: Oracle Corporation
Message-ID: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
Date:   Tue, 18 Feb 2020 14:45:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=1
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=834
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=896 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano (and Stefan),

I have some questions about vsock CIDs, particularly when migration happens.

1. Is there an API to lookup CIDs of guests from the host side (in 
libvirt)?

2. In the vsock(7) man page, it says the CID might change upon 
migration, if it is not available.
Is there some notification when CID reassignment happens?

3. if CID reassignment happens, is this persistent? (i.e. will I see 
updated vsock definition in XML for the guest)

4. I would like to minimize the chance of CID collision. If I understand 
correctly, the CID is a 32-bit unsigned. So for my application, it might 
work to put an IPv4 address. But if I adopt this convention, then I need 
to look forward to possibly using IPv6. Anyway, would it be hard to 
potentially expand the size of the CID to 64 bits or even 128?

Thanks,
-ted

-- 
Ted H. Kim, PhD
ted.h.kim@oracle.com
+1 310-258-7515


