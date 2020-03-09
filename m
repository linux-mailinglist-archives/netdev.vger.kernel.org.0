Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7217E510
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 17:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCIQyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 12:54:55 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38248 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgCIQyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 12:54:54 -0400
Received: by mail-io1-f65.google.com with SMTP id s24so9824220iog.5;
        Mon, 09 Mar 2020 09:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBM/EJVByJ1fvt0IaB7s42kBMtrMOfscdKxthc1f01o=;
        b=j7+hIRJ+WeLBqH9JZ71vlz/LU6RkYQnan8oxdrQmew18BkJPxDpnlDDs8qwjyf4S//
         6g/elDvgR2jQK9bQjetKagI64eXB91sAaSx3dWdbExpOSby3rqIq068TjSOY49q3LRJX
         B+gxeLX+9+e+V9rxkzHIy6bDZKe1isOWqYS6CeIzxl9PLIVG62uM6FLB21XuHHwNQsw5
         4MIhCTr8lo091TmPK/2vLwXAUNzV5BcPsOA/hBHHx/oplK6aQeultzspfXxzCom7Sy79
         V+MrWkL2/CTv96Ofq3PF0TuBWLJBDCR9ZKpcwqTcqtjnVRHOXWmWMvt0Sa4ev8N7Klo3
         PpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBM/EJVByJ1fvt0IaB7s42kBMtrMOfscdKxthc1f01o=;
        b=iMNL1TCG3Pl5wBMQdOo4xEKMSGyXK0Yns1b+yQzGlvAqZ/s0D5KkH/+hD6Kr6e76WP
         qCwhnS+Rt5XDlWZ+KV0O+rfwrlsa0jOE6bKj2ser+H4QyR+GC6y+X9Virb3AASMbU82U
         3rPJDskFLI2eJ4TTxM625myTESiUeKYtu0yeXYU49btZIhTSpqOVRiITtCH9JAKv2Z4Y
         UFrEMgceE0wKBvPUKp+cjnHhyMuPJqsXlWjiqOL5q6HjhyLn6vSPG8wJpwI2m8Q18aKf
         mJFFFuIKv59/cVMUVMTX5uxrOfnMGF03GtGSoJXDhUttVEafY6PVsrhPRyFbcq4gZod6
         0GWQ==
X-Gm-Message-State: ANhLgQ129IWz2RpjbwD+tfGG7vqXDyAUsuF/8twSPaFvsgnbCDiGJEdP
        1zvdspc5En07am+QRQE+nOFdqyrEdnz6tLP01sU=
X-Google-Smtp-Source: ADFU+vuolrK6LFWTF1i2AMSm9DahDorblsLbuuPqp++RHjvfHEfl6hLe/NsSx+TCiOg3yJcdPU9Z/vcKwZqJhKtkEUE=
X-Received: by 2002:a6b:3c13:: with SMTP id k19mr14304131iob.25.1583772893973;
 Mon, 09 Mar 2020 09:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200306042831.17827-1-elder@linaro.org>
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 9 Mar 2020 09:54:42 -0700
Message-ID: <CAA93jw5enz6-h1m=7tGFToK+E+8z3aD80pBef4AYkFrS2u3hHQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver (UPDATED)
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am happy to see this driver upstream.

>Arnd's concern was that the rmnet_data0 network device does not
>have the benefit of information about the state of the underlying
>IPA hardware in order to be effective in controlling TX flow.
>The feared result is over-buffering of TX packets (bufferbloat).
>I began working on some simple experiments to see whether (or how
>much) his concern was warranted.  But it turned out that completing
>these experiments was much more work than had been hoped.

Members of the bufferbloat project *care*, and have tools and testbeds for
exploring these issues. It would be good to establish a relationship with
the vendor, obtain hardware, and other (technical and financial) support, if
possible.

Is there any specific hardware now available (generally or in beta) that
can be obtained by us to take a harder look? A contact at linaro or QCA
willing discuss options?
