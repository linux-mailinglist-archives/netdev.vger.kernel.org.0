Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E88C42B3ED
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 06:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhJMEMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 00:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhJMEMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 00:12:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E062C061570;
        Tue, 12 Oct 2021 21:10:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y7so1292303pfg.8;
        Tue, 12 Oct 2021 21:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=veH4x5sZ0wWvTp8mChrhEWWmXKy3+vBBDBajnwyCPHo=;
        b=bHujX44TNM4ZNeM8Us6qSs0RXR591DDGUmWJ7S6H67FtRcZTOPSJQ+rclHDDBmuB30
         YRCm1mtc/G4Jd3IBWJ89fXSBim+PMdBuTB9gRcM67hKJrM9sKP1Rn/PAW99zlEwq8vAI
         iwQqCuqKvpaTE2MkVRFVImAqPIZ69vcafp+H2rjvJvHL8N0c9Ptr/JHSaDt9vI9ds38g
         hz4ZrHhUI00X4zQFgWEPvHRbxnZZwmtMKitu1JKd1N+9uA5FG/zCdBTdpDpnLG552bhb
         9cpaxdRZI1k5G1Mw20R8sIYNW7f/pNmlWN3EOHhxbkvotmReIwOPeXRXaFNCZNrav6lA
         TEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=veH4x5sZ0wWvTp8mChrhEWWmXKy3+vBBDBajnwyCPHo=;
        b=aPWJe8Sqt+fuvMkG/QcG5b31wEJKEHQmUIbCtEJB8JeVjODmqJBkOc7zld6lwypu2m
         T61OOTb/tQhljrfWzaU1+c7K28flRhIY7dkbSFGLsD7xqeFU8sXmmXr/8YKB8NkWcKxc
         xn6LEPaEeTQGmcTFDJ5OcUP+m4N5nEA8F7TG0ws0iatcrKJ8oGVPAYa8ON68U2arUBDL
         RKidr7yu5hFlMrTAy5OjvgVBcdUywiIhcBDAn0t7+sqIcsXa8DmmbmxrCQpuvGNJ7QP4
         hftadNJdnJZNgsTmbzHXk4jTcIR6ojdx+VkQTrRQKrcwYXggjNaRmAmyykEE3WWSjTZI
         NlkQ==
X-Gm-Message-State: AOAM531GGcj0DlZHwhfRQDzkL2apPWM8BcXZam0612HZniI6rCGnr7fL
        qM4WbY5GCYjf0IWiDIaLesw=
X-Google-Smtp-Source: ABdhPJxtt2jGRQ+K8fs+/kPUqSUPPWECZP45M29TohvgZXBVADXgymBoXD3hYkSVQl8qTojaPvc+hw==
X-Received: by 2002:a63:cf44:: with SMTP id b4mr26338884pgj.215.1634098213803;
        Tue, 12 Oct 2021 21:10:13 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id z9sm4231826pji.42.2021.10.12.21.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 21:10:13 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 05/16] net: dsa: qca8k: add support for cpu port 6
Date:   Wed, 13 Oct 2021 12:10:04 +0800
Message-Id: <20211013041004.29805-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013011622.10537-6-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com> <20211013011622.10537-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 03:16:11AM +0200, Ansuel Smith wrote:
> @@ -1017,13 +1033,14 @@ static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> +	u8 cpu_port;
>  	int ret, i;
>  	u32 mask;
>  
> -	/* Make sure that port 0 is the cpu port */
> -	if (!dsa_is_cpu_port(ds, 0)) {
> -		dev_err(priv->dev, "port 0 is not the CPU port");
> -		return -EINVAL;
> +	cpu_port = qca8k_find_cpu_port(ds);
> +	if (cpu_port < 0) {

cpu_port should be of type int, otherwise this is always false.

> +		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
> +		return cpu_port;
>  	}
