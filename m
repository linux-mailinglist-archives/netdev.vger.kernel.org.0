Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9537628A23F
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389584AbgJJWzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730683AbgJJTuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:50:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09ADuDaE007956;
        Sat, 10 Oct 2020 13:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=i12gKFPdJZF7+MNGak6f/dG0rwxLvrt1hj8h/auKFIM=;
 b=i3B+00Fw5SbY6EVbiQNLLPR6tws9qmpxGO+ceQ9+WCQo8jZr+1wh0Str4khZHDYbkulQ
 mUlfE9rcwyem83dZ3H332uHmzlnTMeaLtwzXfA6FaSzN10gsjUx2+RfsPNBQFWl1mNYN
 PZken3BLB3B+Y/3eJqxhfr7GdnztnvxOWC0ZgKr9cubmax2akxHUIKIcpfnmPjCwhxfd
 u3a3f7XlF7Gd+eUXeR6HZkAoIzd7opEhgJU+C5Ds2gtB3h8C8/RTUhEciREQXyCy5RJb
 of+1wRTznOsjKJ+h3AW9op3aR1GCjCQQ1bWuRe9r28cZVQektraeeE2GKGPbdd6bLpWd zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wk8rfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 13:56:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09ADpOqP125033;
        Sat, 10 Oct 2020 13:54:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34349jbcjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Oct 2020 13:54:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09ADsBhJ011167;
        Sat, 10 Oct 2020 13:54:11 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Oct 2020 06:54:10 -0700
Date:   Sat, 10 Oct 2020 16:54:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/8] staging: wfx: check memory allocation
Message-ID: <20201010135403.GT18329@kadam>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
 <20201009171307.864608-3-Jerome.Pouiller@silabs.com>
 <874kn31be2.fsf@codeaurora.org>
 <2852079.TFTgQsWz4P@pc-42>
 <20201010131810.GS18329@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201010131810.GS18329@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9769 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010100130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9769 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 04:18:11PM +0300, Dan Carpenter wrote:
> On Sat, Oct 10, 2020 at 02:07:13PM +0200, Jérôme Pouiller wrote:
> > On Friday 9 October 2020 20:51:01 CEST Kalle Valo wrote:
> > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > > 
> > > 
> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > > 
> > > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > >
> > > > Smatch complains:
> > > >
> > > >    main.c:228 wfx_send_pdata_pds() warn: potential NULL parameter dereference 'tmp_buf'
> > > >    227          tmp_buf = kmemdup(pds->data, pds->size, GFP_KERNEL);
> > > >    228          ret = wfx_send_pds(wdev, tmp_buf, pds->size);
> > > >                                          ^^^^^^^
> > > >    229          kfree(tmp_buf);
> > > >
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > > ---
> > > >  drivers/staging/wfx/main.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
> > > > index df11c091e094..a8dc2c033410 100644
> > > > --- a/drivers/staging/wfx/main.c
> > > > +++ b/drivers/staging/wfx/main.c
> > > > @@ -222,12 +222,18 @@ static int wfx_send_pdata_pds(struct wfx_dev *wdev)
> > > >       if (ret) {
> > > >               dev_err(wdev->dev, "can't load PDS file %s\n",
> > > >                       wdev->pdata.file_pds);
> > > > -             return ret;
> > > > +             goto err1;
> > > >       }
> > > >       tmp_buf = kmemdup(pds->data, pds->size, GFP_KERNEL);
> > > > +     if (!tmp_buf) {
> > > > +             ret = -ENOMEM;
> > > > +             goto err2;
> > > > +     }
> > > >       ret = wfx_send_pds(wdev, tmp_buf, pds->size);
> > > >       kfree(tmp_buf);
> > > > +err2:
> > > >       release_firmware(pds);
> > > > +err1:
> > > >       return ret;
> > > >  }
> > > 
> > > A minor style issue but using more descriptive error labels make the
> > > code more readable and maintainable, especially in a bigger function.
> > > For example, err2 could be called err_release_firmware.
> > > 
> > > And actually err1 could be removed and the goto replaced with just
> > > "return ret;". Then err2 could be renamed to a simple err.
> > 
> > It was the case in the initial code. However, I have preferred to not
> > mix 'return' and 'goto' inside the same function. Probably a matter of
> > taste.
> >
> 
> Ideally you can read a function from top to bottom and understand with
> out skipping around.  Imagine if novels were written like that "goto
> bottom_of_page;" but then at the bottom it just said "Just kidding".
> "return ret;" is more readable than "goto err;"

More unasked for exposition:  "goto err;" is too vague.  It could be one
of three things.  1)  Do nothing (like this code).  2)  Do something
specific (choose a better name like goto unlock).  3) Do everything.
Do everything code is the most buggy style of error handling.

The common bug introduced by type 1 and 2 are "Forgot to set the error
code" bugs.  Type 3 is a whole nother level of bugginess.  Too much bugs
to explain.

regards,
dan carpenter

