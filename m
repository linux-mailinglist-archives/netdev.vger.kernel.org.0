Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC1C251B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbfI3Q10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:27:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42870 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731459AbfI3Q10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:27:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id z12so7661263pgp.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fP6cMntggNSnlKHivkRv4pATuOxDMqV+Za9yxGOgm4E=;
        b=o6P4fXunm7py6MppSOz17fL5tOBh+Wp9XgBuqdvciVPsEFeqPQ/OX+TqNahDfojAyK
         MXZffKPHA4NFurLRa3YKgSP843FSZwXvuxAn+gK6LDrBgQ9slQZ+AyXru43HZk9ur01T
         J8lXQVhubmxtBhrFzku8+cUVmOOia1cVPPK29TfdgvSNIK1Bs5HvUhCubl4w31wU0zwA
         aVVXo6xsG3W3F7vx7+HueUKcNvFsM2rpEl7abhSoLomivtntXomApUDcwo/AnrA7RjBt
         4cxMo8np+3yeaOUyIR14nvorUsDq8xqpes/A/8hbI1Zaeu8CvF8o2JLVsisoyyLEDdop
         JUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fP6cMntggNSnlKHivkRv4pATuOxDMqV+Za9yxGOgm4E=;
        b=mzfW8/PfbEpY6zSFXaHoFN+OnMh6uOsja7nzwtxcw9kvL3DkbrwAKEKCXD6XFeUQJR
         wHsY3/vc/5+LhSikMPFR6Rh8msksA2WvSuAc3UqFwc69DderMDmA+v/sQyv4d+dE5Upy
         9889ZZ1LKIJVbJo1Zon5JonjSB75eBCyhgm24HSmbEeqckMayBjbL+o26MXCxjKBYMZ0
         CWUM7oZcOXIuNV0rNBWmtxePt8aUIFGJH65Jygwzu8GEZi2khQRS+caeX8N2XRhe+fuv
         yOiqueqIQOUnsxtVvktsqBC3tojsf25u1o5SfLZfhwaRppxPZIfutgpsn4n1PAn+Oq5q
         Yp3g==
X-Gm-Message-State: APjAAAXU39Ed5MBtr35Trh5NfmkSwDvsh49qKgs7mW7IEBw4rmKfiryU
        VYMxUELpCVZgPIsQwKLrzMKV6Q2H3dMUEg==
X-Google-Smtp-Source: APXvYqxEv4quAMWdjXeHuSPVNatwF/bu0ggi1Kvmpn45PZOBSKoG1sSteIovpbvZnM2kuQat2lTNtw==
X-Received: by 2002:a17:90a:3aa6:: with SMTP id b35mr81383pjc.94.1569860845560;
        Mon, 30 Sep 2019 09:27:25 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v15sm13869053pfn.27.2019.09.30.09.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 09:27:25 -0700 (PDT)
Date:   Mon, 30 Sep 2019 09:27:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 1/2] ip: add support for alternative name
 addition/deletion/list
Message-ID: <20190930092718.2d3a47ab@hermes.lan>
In-Reply-To: <20190930095903.11851-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
        <20190930095903.11851-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 11:59:02 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> +		open_json_array(PRINT_JSON, "altnames");
> +		for (i = RTA_DATA(proplist); RTA_OK(i, rem);
> +		     i = RTA_NEXT(i, rem)) {
> +			if (i->rta_type != IFLA_ALT_IFNAME)
> +				continue;
> +			print_string(PRINT_FP, "NULL", "%s    altname ", _SL_);

You can pass real NULL versus quoted NULL when doing print to file only
