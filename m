Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12F45A370A
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiH0Kgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 06:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiH0Kgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 06:36:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86876BD4E;
        Sat, 27 Aug 2022 03:36:40 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m10-20020a05600c3b0a00b003a603fc3f81so2032585wms.0;
        Sat, 27 Aug 2022 03:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc;
        bh=3KdNmwQ5Eo4mNdRhZZD4nhR9AFPFsJ2ICC0mw9B8MGs=;
        b=IMA+D+gGlVerpOdwH6UOhJBppQJ11A1qiZKC6AW4gTnrDBwI8HHmeolvDU74GV0rfg
         Ysoy9iKFhgIiqwCvtN3L+C/zzDH782IRG1YCbbot5JuLaAv2RgcX6nsA/rZy4VBzk1tD
         BB02VykcQsOLblkEiD8xweR9Bt4QXx0f/j5ZBBcnZYkX/5b84kSCpog5pVutqTAx/QKa
         cbXRWqbhGN+PYc2oYolQeM/szmc2Ebfarew18c0ByiZHDKkruFO7lDw+L/cIXB4+ZOcm
         /ODVPtxHee1y4g/t80NbNXA1wORleJtZ1nVzLm21cgDNTdgIzCFGxJNRqOV9TkFObFLj
         Juow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc;
        bh=3KdNmwQ5Eo4mNdRhZZD4nhR9AFPFsJ2ICC0mw9B8MGs=;
        b=8KMYhIL8FvDmQ5cSOeugAHZxqiHQpmgODMncUXzHhVE1kWIxtVzROLul5ocpt0pCUy
         f5m16o1UJblisYT/pp1J6ajEmpTp1jifY0fSbqiVvpEMMJOxgFsn3EYJSgVTsCGRSAvr
         EAtDU51XKSpHdn8zceURKcwPxssa4PDsRc/DqkdJSnHScST7WWblPotUkYw0yhHG9nUF
         3sFkSsUFpcqm4HzSiAI61in2pS4+gTbHAE7NeyAp5UkxngztlPDLgyZXk1u2L6edyIn8
         dfR6lI9cx9onwp1CUzUAVMu0k6+LeBDBvBx3XVBsp2scekB4hBC9NNlNOAKwFMYe7GWy
         o+4g==
X-Gm-Message-State: ACgBeo36XJ/llIYEdtYIe4lBUedAi7yEqq+/WBFKSe6qVv4DQe8fGfzF
        p9nIpNGZj8KO8KLlJssewLA=
X-Google-Smtp-Source: AA6agR7L3WSvfGpwK8d3UEcMZdevgO2kd0FBzNAB3RIXaLZD378C68ZcHWsq4S0lmqLqJDVoEVynHw==
X-Received: by 2002:a1c:f709:0:b0:3a6:3452:fcbe with SMTP id v9-20020a1cf709000000b003a63452fcbemr1991486wmh.164.1661596599428;
        Sat, 27 Aug 2022 03:36:39 -0700 (PDT)
Received: from localhost ([84.255.184.228])
        by smtp.gmail.com with ESMTPSA id c6-20020adffb06000000b002250c35826dsm1952077wrr.104.2022.08.27.03.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 03:36:38 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 27 Aug 2022 13:36:29 +0300
Message-Id: <CMGQTZ9XBSTJ.5QY7JQCNULBN@Arch-Desktop>
Subject: Re: [PATCH] ar5523: check endpoints type and direction in probe()
From:   "Mazin Al Haddad" <mazinalhaddad05@gmail.com>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     <pontus.fuchs@gmail.com>, <netdev@vger.kernel.org>,
        <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com>,
        <edumazet@google.com>, <paskripkin@gmail.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <davem@davemloft.net>
X-Mailer: aerc 0.11.0-85-g6b1afc3ae3d8
References: <20220823222436.514204-1-mazinalhaddad05@gmail.com>
 <YwW/cw2cXLEd5xFo@kroah.com>
In-Reply-To: <YwW/cw2cXLEd5xFo@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Aug 24, 2022 at 9:04 AM +03, Greg KH wrote:
> On Wed, Aug 24, 2022 at 01:24:38AM +0300, Mazin Al Haddad wrote:
> > Fixes a bug reported by syzbot, where a warning occurs in usb_submit_ur=
b()
> > due to the wrong endpoint type. There is no check for both the number
> > of endpoints and the type which causes an error as the code tries to
> > send a URB to the wrong endpoint.
> >=20
> > Fix it by adding a check for the number of endpoints and the
> > direction/type of the endpoints. If the endpoints do not match the=20
> > expected configuration -ENODEV is returned.
> >=20
> > Syzkaller report:
> >=20
> > usb 1-1: BOGUS urb xfer, pipe 3 !=3D type 1
> > WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0x=
ed2/0x18a0 drivers/usb/core/urb.c:502
> > Modules linked in:
> > CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150=
-g32f02a211b0a #0
> > Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google=
 06/29/2022
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >  <TASK>
> >  ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
> >  ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
> >  ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [i=
nline]
> >  ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:165=
5
> >=20
> >=20
> > Link: https://syzkaller.appspot.com/bug?extid=3D1bc2c2afd44f820a669f
> > Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotma=
il.com
> > Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ar5523/ar5523.c | 31 ++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >=20
> > diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wir=
eless/ath/ar5523/ar5523.c
> > index 6f937d2cc126..5451bf9ab9fb 100644
> > --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> > +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> > @@ -1581,8 +1581,39 @@ static int ar5523_probe(struct usb_interface *in=
tf,
> >  	struct usb_device *dev =3D interface_to_usbdev(intf);
> >  	struct ieee80211_hw *hw;
> >  	struct ar5523 *ar;
> > +	struct usb_host_interface *host =3D intf->cur_altsetting;
> >  	int error =3D -ENOMEM;
> > =20
> > +	if (host->desc.bNumEndpoints !=3D 4) {
> > +		dev_err(&dev->dev, "Wrong number of endpoints\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	for (int i =3D 0; i < host->desc.bNumEndpoints; ++i) {
> > +		struct usb_endpoint_descriptor *ep =3D &host->endpoint[i].desc;
> > +		// Check for type of endpoint and direction.
> > +		switch (i) {
> > +		case 0:
> > +		case 1:
> > +			if ((ep->bEndpointAddress & USB_DIR_OUT) &&
> > +			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> > +			     =3D=3D USB_ENDPOINT_XFER_BULK)){
>
> Did you run your change through checkpatch?

Yes.

> We have usb helper functions for all of this, why not use them instead
> of attempting to roll your own?

Using the helpers is indeed a lot better. I wasn't aware of all of them.
Since find_common_endpoints() won't work here, I used the helpers for=20
checking direction/type.=20

I'll send v3 now. If there are any more changes that you feel
are necessary please let me know, I'll be happy to incorporate them.=20

Thanks!
