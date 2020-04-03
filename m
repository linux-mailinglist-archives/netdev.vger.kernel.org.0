Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0F19D1AF
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390388AbgDCIEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:04:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgDCID7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:03:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03383bua041820;
        Fri, 3 Apr 2020 08:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uVaVWvGK2rRDzlNOFOUMvxplXsbxRH2vt/0XQlDzCsY=;
 b=twbeWOniMJLadbk7nycMgbesUu2TjHH3UQD7dFhYGpMwTvQ9/9/esw2i6D2PYeCt/+rn
 YeXF1WEdUoFx8+8tpT3V8D6xU9BiTlpI8XqEhOxdMMbLFaGO7GRZBkt9pkoSnD1mlpOM
 06/sINYAp/V+WtUCiKqAjzAQ7iTzDhTtsDuOTVBCdV+cp9RtHRrXVRPVSwWJLgcgsSO1
 By9NpKzyIUa8ly2xRYd6rndixWBm8jZtuQ+1bwixTtoC94Mhn1dqsO4DWTuTEHEyz/kK
 QKo6tW/fszw6arvGThpgrG9QtZ2jhOh7PTVla1+NJw7ls8XGUuGue86WjMCqqktjZKM0 OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevfkbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:03:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03382Drn142883;
        Fri, 3 Apr 2020 08:03:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga41tmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:03:45 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03383h3E008767;
        Fri, 3 Apr 2020 08:03:43 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 01:03:43 -0700
Date:   Fri, 3 Apr 2020 11:03:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 00/32] staging: wfx: rework the Tx queue
Message-ID: <20200403080335.GU2001@kadam>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't quite finish reviewing these pathches last night.  Looks good.
You will need a check on "ssidlen" to prevent memory corruption, as
discussed in patch 1, but that's not a bug which was introduced by this
patchset.  None of my other comments really applied to the patchset
itself, just to the surrounding code.

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

