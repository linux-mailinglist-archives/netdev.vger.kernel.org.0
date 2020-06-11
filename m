Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB31F6FC7
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgFKWSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgFKWSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:18:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDBFC08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 15:18:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a45so3487399pje.1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 15:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eIuvM/OKnK+zQ/LartuQZpG8vXnwcvR8INYrEn0R5R4=;
        b=NUyFh8Q2TnsU8ltEQNe7J7LwTSvZrB6Cq9gkQ7p5A+Clk29jyYVy8MNifGzGpV0zyZ
         PEefeHax6ZoqLeSb3VVRP+PWkxrj+RrpbBJvfMYIik97YLFmrzXlPgFlbQz5KZjU8gy6
         FD+sskFw5KdEPWJsl4GqjpBpU/RMvJH+MIeGfKV8MYs70gu+EUZF+hWwSPw0kfDwHPle
         ZbucTPb38yKN7iGYzkXH9gaSR7BxD7Mht9ZCh5JiXI/1CkOOqHHKvlkmi7otROPHv3e2
         l1jqDX7qi+7Ebe4cwalx9dTi+SXNrcCsHzUONy8SCpODoHUcEfAsjN7me19JZKYjoVqy
         VUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIuvM/OKnK+zQ/LartuQZpG8vXnwcvR8INYrEn0R5R4=;
        b=oCCckrETPV9jYE5UCBix/msHxRL2Dw+qnChWmUM8s1s9C4RYEuR3L70QhDrL/Xt5FZ
         qxaQ+j3Jh20fLO7JXnTl2HFiughTO4fq2wkfSsJvtWGs+Qx44JA3PN2ApilAC8rkt3SG
         2Pv9xbDn5ooXcNaqClqHf07HUlInhRSua2hq/fy7Jmp1b1T60hCuUqfHQxvl6Z8+cplU
         CI3UhbaVtW0AcgOkkt1dKYrwkdaW2pRrFq9yTZSQi4dAnN7Wa42z6zeu6jrnWVCGVa5H
         Rcy6nhkI8EYq4gdJRcwH+IvchkPh6FeGpSX5sEx5qvOK6XIpAIcxLRPncbrFTle8Z5N3
         iTfA==
X-Gm-Message-State: AOAM5334MvbWzKleJ4RDya0b/ppZACBtrtPF39O++HeRsZ/uXssYjdai
        sgfcvATqaEj4ug/0hxlJwSGRmA==
X-Google-Smtp-Source: ABdhPJwGLgBVqD466hTlBYJLbaLCOy72mLHwmyH1kGI2DFm6zhwNicxqC3HQ2ZEkoZ3+VYJ2qM7xvg==
X-Received: by 2002:a17:90a:b013:: with SMTP id x19mr10429690pjq.229.1591913931484;
        Thu, 11 Jun 2020 15:18:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t186sm2670253pfc.39.2020.06.11.15.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 15:18:51 -0700 (PDT)
Date:   Thu, 11 Jun 2020 15:18:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "klassert@kernel.org" <klassert@kernel.org>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "luobin9@huawei.com" <luobin9@huawei.com>,
        "csully@google.com" <csully@google.com>,
        "kou.ishizaki@toshiba.co.jp" <kou.ishizaki@toshiba.co.jp>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "chessman@tux.org" <chessman@tux.org>
Subject: Re: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Message-ID: <20200611151842.392642c5@hermes.lan>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
References: <20200611173010.474475-1-kuba@kernel.org>
        <20200611173010.474475-2-kuba@kernel.org>
        <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 21:17:49 +0000
"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com> wrote:

> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, June 11, 2020 10:30
> > To: davem@davemloft.net
> > Cc: netdev@vger.kernel.org; linux-doc@vger.kernel.org; Jakub Kicinski
> > <kuba@kernel.org>; klassert@kernel.org; akiyano@amazon.com;
> > irusskikh@marvell.com; ioana.ciornei@nxp.com; kys@microsoft.com;
> > saeedm@mellanox.com; jdmason@kudzu.us; snelson@pensando.io; GR-Linux-
> > NIC-Dev@marvell.com; stuyoder@gmail.com; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; sgoutham@marvell.com; luobin9@huawei.com;
> > csully@google.com; kou.ishizaki@toshiba.co.jp; peppe.cavallaro@st.com;
> > chessman@tux.org
> > Subject: [RFC 1/8] docs: networking: reorganize driver documentation again
> > 
> > Organize driver documentation by device type. Most documents
> > have fairly verbose yet uninformative names, so let users
> > first select a well defined device type, and then search for
> > a particular driver.
> > 
> > While at it rename the section from Vendor drivers to
> > Hardware drivers. This seems more accurate, besides people
> > sometimes refer to out-of-tree drivers as vendor drivers.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>


How much of it is still relevant and useful?

The last time I checked, lots of this had bad advice about settings.
And there was lots of drivers documenting what was generic Linux
functionality

And still there were references to old commands like ifconfig or ifenslave.

