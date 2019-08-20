Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE59571A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 08:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfHTGHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 02:07:12 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39941 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfHTGHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 02:07:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so3568042qke.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 23:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=aQ3Nivq+5rvRoOxM4vD1Hh8XJU/PbSq+Ny0bUNmewCk=;
        b=V0I1d/HMfMHT0jQB1mABam7GFmynu+BZxTQBqpjCzWD54cdPXCyclWt6v/EMLX+vN3
         5RagY4jwAHQv8JQ52wGb/S9pUXfgTrWi6rNG790M/KKltbVKSuaLl6n9E7z7trdu8ogQ
         3ie28qXwUjO7cD23cvsVjgHj2byqxqJciDB64UVm/e8MmwK3CvkW2DLhHVFgM/7nGx7c
         35OfYhobLQDv9BEbt68paZNAZhMLQEig1BEFXnp9XfDYnIwmHrQwdyxlr33rlczgaHVn
         fkrV5JrfmCHygBojY6nIikiFHOXIVYngRr8ktc+a+yrwXWVZFN26pweExBUPY7N2fgFZ
         h5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=aQ3Nivq+5rvRoOxM4vD1Hh8XJU/PbSq+Ny0bUNmewCk=;
        b=YXmDKRCqlITn1WEqy5i9bLyQj2QRIfaG0nLlRCL3UwXXXS6Yj/39i9CBdgmBbuqj6c
         nKI/G9k1rwZmgftpODw/eIzmsjIsGUJoLJ6tprTkOXchuJy2IAoYvleFat9VgVq7Dadk
         nZDQvepRsTWd8PFiPN7Cu0Pv92hFyL6xCpJ2vs0PzSDrwoB9OMSKOLj0ZObj0uErKjuQ
         mGlFHmfyz7s5Fgiz4raiHeH1RhAdNpVr7hOCUrxLe68ggris1xSEi5jLoVVSP6or6vQ3
         JzzvMzIBYI+1ItalkxbvqVcJBb/1uQ8pIgCt1B/Gk8V6xg1VRgZZvPaY3dUQW2esNUjv
         4OHQ==
X-Gm-Message-State: APjAAAXuWi25qza0hnGqb5PNiLlSvNmKVm8psHPY71+743peDaD/KuPN
        uLyFGBt52ikZ41/VA9yejmE=
X-Google-Smtp-Source: APXvYqziwukZV4Wzo+32DQ/UuxduVhAd+CmvKG3Y2p55zOCoOLAiEV9IZg1VRSMRVgN682UGAUwQwg==
X-Received: by 2002:ae9:e411:: with SMTP id q17mr23660575qkc.465.1566281230918;
        Mon, 19 Aug 2019 23:07:10 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j27sm3058582qki.9.2019.08.19.23.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 23:07:10 -0700 (PDT)
Date:   Tue, 20 Aug 2019 02:07:09 -0400
Message-ID: <20190820020709.GD975@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on
 the upstream port
In-Reply-To: <20190820000002.9776-5-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 03:00:00 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> programs the VLAN from the bridge into the specified port as well as the
> upstream port, with the same set of flags.
> 
> Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
> user port 2, etc. The upstream port would end up having a pvid equal to
> the last user port whose pvid was programmed from the bridge. Less than
> useful.
> 
> So just don't change the pvid of the upstream port and let it be
> whatever the driver set it internally to be.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/switch.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 84ab2336131e..02ccc53f1926 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -239,17 +239,21 @@ dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
>  			       const struct switchdev_obj_port_vlan *vlan,
>  			       const unsigned long *bitmap)
>  {
> +	struct switchdev_obj_port_vlan v = *vlan;
>  	int port, err;
>  
>  	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
>  		return -EOPNOTSUPP;
>  
>  	for_each_set_bit(port, bitmap, ds->num_ports) {
> -		err = dsa_port_vlan_check(ds, port, vlan);
> +		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +			v.flags &= ~BRIDGE_VLAN_INFO_PVID;

So you keep the BRIDGE_VLAN_INFO_PVID flag cleared for all other ports that
come after any CPU or DSA port?

> +
> +		err = dsa_port_vlan_check(ds, port, &v);
>  		if (err)
>  			return err;
>  
> -		err = ds->ops->port_vlan_prepare(ds, port, vlan);
> +		err = ds->ops->port_vlan_prepare(ds, port, &v);
>  		if (err)
>  			return err;
>  	}
> @@ -262,10 +266,14 @@ dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
>  			   const struct switchdev_obj_port_vlan *vlan,
>  			   const unsigned long *bitmap)
>  {
> +	struct switchdev_obj_port_vlan v = *vlan;
>  	int port;
>  
> -	for_each_set_bit(port, bitmap, ds->num_ports)
> -		ds->ops->port_vlan_add(ds, port, vlan);
> +	for_each_set_bit(port, bitmap, ds->num_ports) {
> +		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> +			v.flags &= ~BRIDGE_VLAN_INFO_PVID;

Same here. Did you intend to initialize your switchdev_obj_port_vlan structure
_within_ the for_each_set_bit loop maybe?

> +		ds->ops->port_vlan_add(ds, port, &v);
> +	}
>  }
>  
>  static int dsa_switch_vlan_add(struct dsa_switch *ds,

Do you even test your patches?
