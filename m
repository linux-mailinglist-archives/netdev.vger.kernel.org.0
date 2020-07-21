Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6202273CD
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgGUA30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgGUA3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:29:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CF3C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:29:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so9889570pfe.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M/7GQ37ZptkgsiJsFu2SHE6HYMxz3VTvQps+vVF3J7k=;
        b=lv9CIkdFjyScAhPWc6HS6Ms5Dln0u71dXOH58htMUX6IoEqo0ktOkoyHup3njBx613
         cFwf5QnWP/YcteciDGDNI3Q1vKca5mlP5CZeZJdq+nZQuljTV9uGuq2Tp1F/m6sllUJ9
         jfP/vo2ePDwlKfUw+TwoAlzDq4tzLbHblEBLtrPBGF64ztxwaH4OMbpuOs2Wh2KzoGmS
         9REMX8mYO2bkQ9/LrnESB+vSmQYqlr6rZF6a9vKNq4tyjK/YS/JhX5OYx/Kox7C8w93Y
         //I/9QVAL37jezQGJg2AXk2q4AI7p0dNssyOuhc5By3SZJs9yOZewTlAq/OKcobMpIyI
         e1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M/7GQ37ZptkgsiJsFu2SHE6HYMxz3VTvQps+vVF3J7k=;
        b=XwNhCQ+or0oV+iImdQAFlwM2uYOQ2mMN3ACg8pUwS+PFHnzRyKgFS147I/PpX8ah/V
         B9sEaqD4aMfbqb6u26uOpr5CXHMMdKi+MFLv9iq1P7RlFg736Fl4GO1yl64pnPF8Y6uV
         HnJvPpmiGwk3eU+ZpVuGYvwBTPnliN55TGs46DJIxuxlHLlmccNOuOi/b2l78K+lfcKC
         Z4QqpwI+GgvH71554CcpnTslb+h8KdASujLPEIc1CXkGSb0PvLYUJCv0IqvoTBCpgUUR
         cUn+c1VVNK0uf8kyb3QkBxC3seimAbJXC0KC1siHFbmP3DhkF8qprCz4b7LV6TLd1DKw
         HPhA==
X-Gm-Message-State: AOAM532WkL4iBCb6Qdq/rFv/k6LKePsWPc89JJ9S/h48luwy4fszqEUv
        +gxnjK/wexj7v7wAIIVpz88=
X-Google-Smtp-Source: ABdhPJzVLKaQDrbue19kj09/E3n2NEli6U4qAjXF4loJ/xY4qTiOYkjt4Cx5gwvMDXW7Ail2Cx3Q9g==
X-Received: by 2002:a63:8c5a:: with SMTP id q26mr19917929pgn.312.1595291364827;
        Mon, 20 Jul 2020 17:29:24 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id kx3sm758038pjb.32.2020.07.20.17.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:29:24 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:29:22 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/2] testptp: add new options for perout phase
 and pulse width
Message-ID: <20200721002922.GD21585@hoboy>
References: <20200720175559.1234818-1-olteanv@gmail.com>
 <20200720175559.1234818-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720175559.1234818-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 08:55:59PM +0300, Vladimir Oltean wrote:
> Extend the example program for PTP ancillary functionality with the
> ability to configure not only the periodic output's period (frequency),
> but also the phase and duty cycle (pulse width) which were newly
> introduced.
> 
> The ioctl level also needs to be updated to the new PTP_PEROUT_REQUEST2,
> since the original PTP_PEROUT_REQUEST doesn't support this
> functionality. For an in-tree testing program, not having explicit
> backwards compatibility is fine, as it should always be tested with the
> current kernel headers and sources.
> 
> Tested with an oscilloscope on the felix switch PHC:
> 
> echo '2 0' > /sys/class/ptp/ptp1/pins/switch_1588_dat0
> ./testptp -d /dev/ptp1 -p 1000000000 -w 100000000 -H 1000 -i 0
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Thanks for following up with this!

Acked-by: Richard Cochran <richardcochran@gmail.com>
