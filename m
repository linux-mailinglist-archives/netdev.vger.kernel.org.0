Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200CA6C07D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfGQRgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:36:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34014 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQRgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:36:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so11189055pfo.1;
        Wed, 17 Jul 2019 10:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AEjoDdJMIzeflgkExnRt8ZGteBiC6Dg9NI5aSUpgDNI=;
        b=uJfl8nmKNeAE9U8+6415p7ApMqk5SuluNv8zlj8GAurFJGMiSVb6zBFoIlp4ERNaNy
         INIbsu5CW3MjVDPs5hxiLEqFjD+oSE3qGPkil2e3ezkqOoMTwn5lh7+UOKcl3QZmvL29
         igXMXXpJeW4v8PF9oTrvLQt4XTQ26xeU1epDJKVEG2sVtzIdmU1UE8Zw1FFHqFiN0dmB
         gRtHIdOA4JEJU+0EHsruxdgJUJ7TNGz8sOXFzVWc/xS6jnfEd+nTgFx71VipIA/ToCEI
         dVIr5XokghsUCPuo2uFE/2v9Wr91O4O95J0gGToWCHL4me864+4F2CGmZQ1f3PRXybFD
         7OUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AEjoDdJMIzeflgkExnRt8ZGteBiC6Dg9NI5aSUpgDNI=;
        b=Ehdfsx8vy2owXKqiemN6j9MpS/8bk7Y2Jhdscs6Kxn8zZdkKC03/edWOln7xxjCyP2
         3W2rjKugehCOJgqCFJGxPNNZNmgAR6h0a9ddYVqW9adgeyXASQsu/GMP+e2OSLhWd90+
         pyPBMP2yjhkocoGY0/cDnuQHeumnTiRpdYgCCtysK1/2DL1IchOAnIL/tDwEkb1Urorg
         VzrJKEV8T7pBMYEYbeWSRNIAmLy5mWjcuCUr2QhrX2sJmSlRnWt4CYI9ZyfISbJMnMQ5
         w/ReheiNycU4tR0mlc1V7/oMtKU76HthJBSqAY4uYpev+KY5eRRqqoU6FzWSwZs8/V1r
         vrqA==
X-Gm-Message-State: APjAAAV3FUrz5W/jJuPdupCRvR+JhYJd0TFKXC51ysXsyJvLUyR5CqHC
        TbFxRlIO1CJA9RzovyABaLY=
X-Google-Smtp-Source: APXvYqxZFXxVDZvHXhEXrcu7anHd6TYVduKou34JRU4OEG5DrhCmv8W/ugMixVYfV4NTPoXvEUs1RQ==
X-Received: by 2002:a63:3ec7:: with SMTP id l190mr44080907pga.334.1563385008207;
        Wed, 17 Jul 2019 10:36:48 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id l27sm2706020pgn.19.2019.07.17.10.36.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 10:36:47 -0700 (PDT)
Date:   Wed, 17 Jul 2019 10:36:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Message-ID: <20190717173645.GD1464@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716072038.8408-5-felipe.balbi@linux.intel.com>
 <20190716163927.GA2125@localhost>
 <87k1ch2m1i.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1ch2m1i.fsf@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 09:49:13AM +0300, Felipe Balbi wrote:
> No worries, I'll work on this after vacations (I'll off for 2 weeks
> starting next week). I thought about adding a new IOCTL until I saw that
> rsv field. Oh well :-)

It would be great if you could fix up the PTP ioctls as a preface to
your series.

Thanks,
Richard
