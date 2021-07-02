Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFB33B9D95
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhGBIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:36:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhGBIgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:36:39 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1628HB0Y023539;
        Fri, 2 Jul 2021 08:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=p1fdxON4YZiX04AnQjMpcG7PIg89DU/zakNCxmA8d5U=;
 b=xrYdjuOW3hKCFKgXnQz0nfUx8p6t1v26rX+dJgCSUuVKfel1pzEJY8lELYS1JZ7KHJqN
 mArOc3sFZ3QfC0jxn+AgjR5R6wpTXFu5vqCWW323s5TXuCOs8wqcDbbCD2TMBn7tNktr
 ynr+Ig5hvBTUoYIgTsd//lgb4UAUGpqnAAnpsD0O6u7Zk4r496Tt5EJS93R/Lrfzb3Ff
 IFpLjy1QJM6PRIrlFfcDQmUUCZCh9fy8/tpbCr1ann6oALkFD69Vu9PTRTC2VYtKhb7e
 2D9mm120UZPlPNqNngPUM7E0N+Bcuu27FUYX73ZNQe5nqz9ViGvXr2dM4WbiOM3UO5Da Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39gguq4yf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Jul 2021 08:34:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1628GCJv016939;
        Fri, 2 Jul 2021 08:34:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 39ee12t8ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Jul 2021 08:34:01 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1628Xxou063457;
        Fri, 2 Jul 2021 08:34:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 39ee12t8x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Jul 2021 08:33:59 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1628Xvkg011095;
        Fri, 2 Jul 2021 08:33:57 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Jul 2021 08:33:56 +0000
Date:   Fri, 2 Jul 2021 11:33:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jeroen de Borst <jeroendb@google.com>, csully@google.com,
        sagis@google.com, jonolson@google.com, davem@davemloft.net,
        kuba@kernel.org, awogbemila@google.com, willemb@google.com,
        yangchun@google.com, bcf@google.com, kuozhao@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/3] gve: Fixes and clean-up
Message-ID: <20210702083347.GU2040@kadam>
References: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
 <CAErkTsQLP9_y-Am3MN-O4vZXe3cTKHfYMwkFk-9YWWPLAQM1cw@mail.gmail.com>
 <29632746-3234-1991-040d-3c0dfb3b3acb@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29632746-3234-1991-040d-3c0dfb3b3acb@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: GV9X0QQKB7necXf1VDT28w9qquFJCvrv
X-Proofpoint-GUID: GV9X0QQKB7necXf1VDT28w9qquFJCvrv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 07:42:48PM +0200, Christophe JAILLET wrote:
> > one for net (with the first 2
> > patches) and one for net-next (with the cleanup one)?
> 
> I've never worked with net and net-next directly.
> If just adding net and net-next after [PATCH] in the subject of the mail,
> yes, I can do it if it helps.

I have a separate tree that I use for sending net patches.  I generally
write my patches against linux-next and then postpone sending them until
the next day.

Then I open my patch in mutt.
cd tmp_tree/
../switch_to_net.sh
cat /var/tmp/mutt-speke-1000-511162-9994856746594827871 | patch -p1 --dry-run
If that applies then I "net" to the subject.  Otherwise I do a
`../switch_to_net-next.sh` verify it applies and send that.

Once in a while I will have to modify my patches to apply cleanly
against the net tree.

It's a pain in the butt and I get it wrong disappointingly often.  I
only do it for networking.  Not for linux-wireless.  There is another
tree where they complain if you don't add a tree to their patches but I
forget what it is...  (I don't use the process for them, only for
networking).

regards,
dan carpenter

