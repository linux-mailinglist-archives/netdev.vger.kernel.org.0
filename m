Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09B8AC6D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHMBVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:21:37 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:42440 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMBVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 21:21:37 -0400
Received: by mail-ua1-f52.google.com with SMTP id a97so40895575uaa.9
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UGP4+hKyNcO1H3itt8gKieN60MFhNC0psdPAjNhEJro=;
        b=PGuAmJL+GLcC7UQp/B7vowzsHgQGgfve+bITEc4T02CHPEpXUMGIIt9fQSLuYW3bIv
         2F0C/Bw39QOwdNdZ6uPEmFqplWZly7WX/3+TmNalv22cXTWMg/yJ7TJDAwVHssuKJD7N
         o2R22qBY8LahgSRl38U56sgLc9DCr1PHIPxJK7JytrRM7n9/IVnVmU3r49QJX7vMPNxe
         eMbStsK0F8c7BuuIUJHjwIBx9hDWAeRY+2hfZOCLk9Govk9aKd5EEhfTXs9UM+7Pprvq
         qfhxw5f4gaXSnpKbfOWpaXyvvwQLkpplDAhkUnluCL9MYGpsYhS+ejfKeU11Q3OlkEty
         Bjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UGP4+hKyNcO1H3itt8gKieN60MFhNC0psdPAjNhEJro=;
        b=IEz6GL2CPVVihjUVDLxtnXMZwglRtrY+1qf0TVptmWZ2KC/ciftoOLjwQx2mSnMDU7
         zo73Xn61HCf0IsPk4k6AWWMQADUwyEI4mPfFlRGj2y0xUMKLU2jzICsgqfdON1AWrQ4w
         wtzZdEv/omb8cxHfw3pen25McXjc4UKeHyOffKyxUJvzdAe+IBAk8Wiwryh9K3Kb3whA
         97dHTcpyqg0ljo+CykE0VOCoy3NPGiAF+Xzh6kAaeZL/xKpQzN4vwy7/vYXStt716F+h
         MKYgwFCniAz7y1tm3orHfPKN3TSx3jb+eiI0Ei8DLbm7iplnrs/lpVZJpK900NJROxG5
         PBjA==
X-Gm-Message-State: APjAAAUetrsK7UrrNZElqiL8GHGuaMif/7AEjD/PnZjc4qngMKdk7OT0
        ritOpqcFJl9Ncd9ofF+yLIPd7w==
X-Google-Smtp-Source: APXvYqz0hAEjYO8E2J7zkZADTay+fEBfZUea1AQko4APoo/vLvoZXDZbG6Zso3hJfTnD0qT9WlcX9g==
X-Received: by 2002:ab0:740e:: with SMTP id r14mr22693066uap.108.1565659293653;
        Mon, 12 Aug 2019 18:21:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u5sm104388270uah.0.2019.08.12.18.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2019 18:21:33 -0700 (PDT)
Date:   Mon, 12 Aug 2019 18:21:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 1/3] net: devlink: allow to change
 namespaces
Message-ID: <20190812182122.5bc71d30@cakuba.netronome.com>
In-Reply-To: <20190812134751.30838-2-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
        <20190812134751.30838-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 15:47:49 +0200, Jiri Pirko wrote:
> @@ -6953,9 +7089,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
>  	return 0;
>  }
>  
> +static void __net_exit devlink_pernet_exit(struct net *net)
> +{
> +	struct devlink *devlink;
> +
> +	mutex_lock(&devlink_mutex);
> +	list_for_each_entry(devlink, &devlink_list, list)
> +		if (net_eq(devlink_net(devlink), net))
> +			devlink_netns_change(devlink, &init_net);
> +	mutex_unlock(&devlink_mutex);
> +}

Just to be sure - this will not cause any locking issues?
Usually the locking order goes devlink -> rtnl
