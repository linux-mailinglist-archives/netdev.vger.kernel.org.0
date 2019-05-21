Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4069D245FC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 04:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfEUCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 22:30:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33627 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfEUCaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 22:30:17 -0400
Received: by mail-io1-f66.google.com with SMTP id z4so12727862iol.0
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 19:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7SgdozFln6N4cKOXj579GcIC6rtza9ecdWL5Wy3TukE=;
        b=nmhwmpIqEdDndur2ChAsWeETvv5l0ZvTBJEtb370hddhGnIxxPPS1QXvF6c0TUXszP
         Yr7EU9Sh4VKHnget+n7Pms3+v3IYuUFGauOnG3iEQESd5l3m1KSETSuhQO5hYGZ1NfHt
         LPiqwzXwYjz5n+bQKEtV3fApV8heGjkpZKbic7oS1/rb9uqKH7lXjUbPcj+woOxmTg4Q
         m0HNFY+GxkdFjyX9PGuOXsaiLoB1kwoZ3BPYPhVnwY5OaAYxdpnZTJTycgmKzxIFJ/Di
         1YbAfj1rHtpuQR8vsAEarxyVT+rLh4FomGP4y8JtjYHxGkxYOASMrUtf7pHzRowINwLc
         5P4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7SgdozFln6N4cKOXj579GcIC6rtza9ecdWL5Wy3TukE=;
        b=ZmUFUpaQ8BN/VhlNShhUeIZvwS0HseNE47f3Sdh64EF8oJFicWs1gEY7UO+l7Upikl
         pREfvewnjA5BWuZhnoXcvbV9MWDmoebltvMBynNrdPeuUEEPJDep3mZE2+S6VYQtXCDd
         9J/y8BKvy/p8yTnFpBNch9mFAYO+qj2lg832kWZiKbDUZFpliUarszO63HRDizeNyzhf
         iN8akCY/hwWY7eP+DgkhostKNwQamRH+DgVKu9OCylLt9WhOpa53yN0Fo9feVCjhpx+e
         49YZrEPvRoXt5ssJcjs0bVe87LojndTVA8WI+xoJ6VzixR8T5F8lSZ25xy+8dJ+cUpem
         WTsg==
X-Gm-Message-State: APjAAAWqakj3GHdnn2t6h6YUWOxfUMeG+5DLsZuZ+NuWIWSlf+mtqeLJ
        bfd5XBPG1gAFcSgmX+l9zV54nQ==
X-Google-Smtp-Source: APXvYqz9vj/PZiRmzYCXa+PAsNaZto+wgavDJl397bLT75uosm0y+5EYz+JwQEdkwKsy3yJZG/Ij5A==
X-Received: by 2002:a5e:9907:: with SMTP id t7mr4471913ioj.24.1558405816298;
        Mon, 20 May 2019 19:30:16 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id c3sm5748728iob.80.2019.05.20.19.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 19:30:15 -0700 (PDT)
Subject: Re: [PATCH 1/8] net: qualcomm: rmnet: fix struct rmnet_map_header
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     arnd@arndb.de, david.brown@linaro.org, agross@kernel.org,
        davem@davemloft.net, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, evgreen@chromium.org, benchan@google.com,
        ejcaruso@google.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-2-elder@linaro.org>
 <b0edef36555877350cfbab2248f8baac@codeaurora.org>
 <81fd1e01-b8e3-f86a-fcc9-2bcbc51bd679@linaro.org>
 <d90f8ccdc1f76f9166f269eb71a14f7f@codeaurora.org>
From:   Alex Elder <elder@linaro.org>
Message-ID: <cd839826-639d-2419-0941-333055e26e37@linaro.org>
Date:   Mon, 20 May 2019 21:30:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d90f8ccdc1f76f9166f269eb71a14f7f@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/19 8:32 PM, Subash Abhinov Kasiviswanathan wrote:
>>
>> If you are telling me that the command/data flag resides at bit
>> 7 of the first byte, I will update the field masks in a later
>> patch in this series to reflect that.
>>
> 
> Higher order bit is Command / Data.

So what this means is that to get the command/data bit we use:

	first_byte & 0x80

If that is correct I will remove this patch from the series and
will update the subsequent patches so bit 7 is the command bit,
bit 6 is reserved, and bits 0-5 are the pad length.

I will post a v2 of the series with these changes, and will
incorporate Bjorn's "Reviewed-by".

					-Alex
