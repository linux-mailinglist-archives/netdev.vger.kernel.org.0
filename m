Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB32D4D0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 06:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfE2ElD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 00:41:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37947 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfE2ElD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 00:41:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so568357pgl.5;
        Tue, 28 May 2019 21:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zL9lv9sTG+iKLhec48eN4v1/JQ2nUHXz7vZc3um0qV0=;
        b=WSEEFKy902+JdTTtrZ6ADDoeMJklntgoh4j+YVNQqlYtwfiwdj5/sS0+nSUpIOS09L
         ZAeXXfKh/BacPTX1SpMNLIlBfnyuCkEcOslDxyIFANFcghvrWRBm4QT/OTkRXeDygbtr
         9/4bzgVCjcYrCHFqltIy7CeiyPay78gXcO7aMMtO/CQfwf+7/zYqQJ7KJ+lGgD6ggLLF
         F3xU6rCbYTbFNbsYEktUNp5Sz3khEuTcJx02Hw4nWN90yp8NtOP9i/vP8gDJ1y1xwG7K
         1EoSnE0gfUFwFg0sO+rd7NLCleTXA7kI40zJ8oJZAbfIUcRSt8XaP0qcnKzOSyVRD/Xy
         Vstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zL9lv9sTG+iKLhec48eN4v1/JQ2nUHXz7vZc3um0qV0=;
        b=WEh9ETcd3iL8rC45YN21bRxC25k+YUIKIAy0jTGtgusQ5VJ/9+99lHe344UMYlMyYk
         PEyosTtUEJPGgTr17J0V41PgsY0s+DAAVg6rGnjWkAdRE94U0yHcQioRU4gaAH+TZm9c
         Q59dRe7yOChPzPYllkDtPPtJIv8tqhAIgjgX8ELvxx54W+zAFBElSZnxx/UXwetKR/M6
         dVvELuAQsqtiWn1+2DkGF8NhGU6q5cODga3eReQGtB00NVHq5Ma1oebRIeJz3l8bcorQ
         Mkw9Mm3J/Yz5PatN5D4XC+BjK2As0LjZ4WsE5ByGBM1DDzHEGydLxoaqb0lPvrFmPjB+
         LbKw==
X-Gm-Message-State: APjAAAUuJm6YKOIT+VeRD8sXyxwzFrJL0YoCh1hJOZBiafitNpOFlKGE
        fvtD6BpvuubPkCVPmKJbaqfEpZp2
X-Google-Smtp-Source: APXvYqwkskd0qIWl5aTsk5PIY219vfFqlSMjj/M9/jhd37RWG3r4z8MHbo3mZDYvglLVAcbM2A9T8A==
X-Received: by 2002:a63:d652:: with SMTP id d18mr26310103pgj.112.1559104862722;
        Tue, 28 May 2019 21:41:02 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id s5sm23592318pgj.60.2019.05.28.21.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 21:41:01 -0700 (PDT)
Date:   Tue, 28 May 2019 21:40:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] timecounter: Add helper for reconstructing
 partial timestamps
Message-ID: <20190529044059.pp36ol5ms6a7w6z5@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190528235627.1315-2-olteanv@gmail.com>
 <CALAqxLWjT0ZJerFa+BVCKW+-ws6DYFy7kqEfNVK8ioGdY=VQeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLWjT0ZJerFa+BVCKW+-ws6DYFy7kqEfNVK8ioGdY=VQeQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 07:14:22PM -0700, John Stultz wrote:
> Hrm. Is this actually generic? Would it make more sense to have the
> specific implementations with this quirk implement this in their
> read() handler? If not, why?

Strongly agree that this workaround should stay in the driver.  After
all, we do not want to encourage HW designers to continue in this way.

Thanks,
Richard
