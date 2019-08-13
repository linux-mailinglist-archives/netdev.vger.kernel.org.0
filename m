Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99868AFB9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfHMGN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:13:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36414 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfHMGN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:13:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so370454wme.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kzWfvmT3z7QW0DJzR/OgLY8B+FWqiZaJCvoLWA3Xqjc=;
        b=BER4lNMvdWj194yOwZ3udjh1L2X3bmuftAKjDG8p8lFVR0BSQQXdAXv22QOoKGJI0A
         CCBCV4TJKD5GumQ7lq5KfeGQ1vq+5TEXMbnnT1srZuY3BCC/sLTLdm6pk28xxTQyVquV
         +Otzjbybh1hes7GMIhYvCmE7Ev5tQU1KIUJ+IHi69IR0weqyxFdXX9iKFw5wLvOFJXXN
         lmBpI4UAKrcnt7H9I61YgETG+tmDOCVLicYTaqxDdJyvT/2pcnTMfoCMsP5GiuYN3Mdc
         M1iiMJj5N5ChG2eq8SaYW/29MDq0E8DTT/vO1NzvYLlNyF2MD20+XQwI8qDUN4+VdpBK
         xubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kzWfvmT3z7QW0DJzR/OgLY8B+FWqiZaJCvoLWA3Xqjc=;
        b=og3LUWM1CPQhaUXGb5rNvv+ydCOmm8W66AvNomrB40m2kwiPOeWHeyt/B0KzrAfvEW
         l6EfXYuOxt45hZwg3LVX+CA1r2AYlGj312GHqIorhTC6h/FVSOOSPCNQUcWK4OSqRmEW
         FleKlCF6UZnU+/wWPy6F+BypJ+ZDo1BLvhuoSD/M4OECfn4mfkeHZE2JHVCQtNB6o232
         juSOO1tpOaHSQ8jvvHYgGKvDQRwQeYvF95kc1ot4+BEwga8wRIKMPhgdNjfq3x+zudfJ
         aXI4/3q3kweQtdnE1SGlEs+LdriPExU6g0x4RCApT+Ha3Tij2NWtK3GFsu7Dn9PAwYDt
         zH8w==
X-Gm-Message-State: APjAAAV0TbGMIn8fHJI19Qp4hFRpMREEV0QSJAlnzxK7K76fZTasDYzK
        DtWgSqtFU5/wNGmmDZ5Kkr8qHL+Ubeg=
X-Google-Smtp-Source: APXvYqzZq/WBeLVmFdgxhYMgPylYRtiPKF25agbohk0XQVhCxEGS/Y5PXNkQeCFr2xwj41BRIr+deg==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr1030460wmb.98.1565676836542;
        Mon, 12 Aug 2019 23:13:56 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id t63sm456396wmt.6.2019.08.12.23.13.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:13:56 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:13:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 1/3] net: devlink: allow to change namespaces
Message-ID: <20190813061355.GF2428@nanopsycho>
References: <20190812134751.30838-1-jiri@resnulli.us>
 <20190812134751.30838-2-jiri@resnulli.us>
 <20190812182122.5bc71d30@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812182122.5bc71d30@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 03:21:22AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon, 12 Aug 2019 15:47:49 +0200, Jiri Pirko wrote:
>> @@ -6953,9 +7089,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
>>  	return 0;
>>  }
>>  
>> +static void __net_exit devlink_pernet_exit(struct net *net)
>> +{
>> +	struct devlink *devlink;
>> +
>> +	mutex_lock(&devlink_mutex);
>> +	list_for_each_entry(devlink, &devlink_list, list)
>> +		if (net_eq(devlink_net(devlink), net))
>> +			devlink_netns_change(devlink, &init_net);
>> +	mutex_unlock(&devlink_mutex);
>> +}
>
>Just to be sure - this will not cause any locking issues?
>Usually the locking order goes devlink -> rtnl

rtnl is not taken. Do I miss something?
