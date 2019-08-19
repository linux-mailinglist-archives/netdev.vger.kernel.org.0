Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299B992854
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfHSP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:27:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45089 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfHSP1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:27:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so1718731qki.12
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=FQ4MSexiAjWhQJlJfac2gGYs70GEnnOh/hYCjFYncqE=;
        b=cnoVBGy/G0/MYV6di4Hs2b1onn7ufT8+oYgUnB5PIzRN14U6GhwZTQ6ekwQY0xEUG+
         Uf20+l7i2Y0yITw/uE2ErittPN2IBKHV+d6FeScNp2qIQWFUyRLmjjTDKhjGPWGi2UqO
         nWobUVbwl+znNxXGk4iT4E3JweVC0hF+8C/9wD6ZNhX7KwOLpwL/Xp7po7QXb/KCYIux
         MjmEzfUk7bi5YchoD4xZnlKcIUvh7glYjsNVc0fB0XnHFsnbC1FlMMGL6yB1+cZqp6Fr
         tGwQQ6YRXq+Bqy/F4nABsGG4YJJkKDPJU7UCk84jRHM7XMFVZ65NSD0o0LBaryjomgyx
         QgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=FQ4MSexiAjWhQJlJfac2gGYs70GEnnOh/hYCjFYncqE=;
        b=B7sAImg8z6WotPkp/o+peDphRQsyHQrLxnEhsoHeFV+yXv4u5vAISAvIY9i5PsEXQr
         QrsPMRiN6ZjPsCK712Wl8CS4N4hWIFAWF3WJZgkNMbF0//jO+VbV7JT7QC08AliBcpC1
         aAEidG6c1balWu0xvnq1aTDGSbWvht34Ux/AEWGlSvo6LoJsc3cuiEmnXzntnxpszkPw
         /g34PxRynWruemt59HT/JfbCwldSGO3Up7DzR2nCZB2qd0rUueCiYHqdpE5RoubvxzEE
         jX3Au6vr/jQoF7NEkD9xYvHMlQb1jJiGFFJ/5r4p4iuTKsNYZVl1XRPZmAvcyavl+W2j
         McZQ==
X-Gm-Message-State: APjAAAVzkv9Z6VU+sp88rQ1W521pqooCD4QytR+VxrPEJ/Hm1/dxcCi+
        BcZghRxR0fVpLkK6hiA8IZo=
X-Google-Smtp-Source: APXvYqwCMEr9GEZVamu5B70JRE+pEk39dqcoUhQMtdXXY9UR2TTBbvcTFKFqoGfMQmVnlJ7vv5GwFQ==
X-Received: by 2002:a05:620a:621:: with SMTP id 1mr18536979qkv.380.1566228455214;
        Mon, 19 Aug 2019 08:27:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c11sm6758695qtq.41.2019.08.19.08.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 08:27:34 -0700 (PDT)
Date:   Mon, 19 Aug 2019 11:27:33 -0400
Message-ID: <20190819112733.GD6123@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP state
 on port disabling
In-Reply-To: <20190819134057.GF8981@lunn.ch>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-5-vivien.didelot@gmail.com>
 <20190819134057.GF8981@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 19 Aug 2019 15:40:57 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Aug 18, 2019 at 01:35:46PM -0400, Vivien Didelot wrote:
> > When disabling a port, that is not for the driver to decide what to
> > do with the STP state. This is already handled by the DSA layer.
> 
> Hi Vivien
> 
> Putting the port into STP disabled state is how you actually disable
> it, for the mv88e6xxx. So this is not really about STP, it is about
> powering off the port. Maybe a comment is needed, rather than removing
> the code?

This is not for the driver to decide, the stack already handles that.
Otherwise, calling dsa_port_disable on a bridged port would result in
mv88e6xxx forcing the STP state to Disabled while this is not expected.


Thanks,

	Vivien
