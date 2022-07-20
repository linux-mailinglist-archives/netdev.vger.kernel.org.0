Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFE57B652
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiGTM17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbiGTM1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:27:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5FC70E48
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:27:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mf4so32787936ejc.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/AkHj7J7SxrkCHNNUXYijsTUpAYsLcw3KIOqALTlzwM=;
        b=g322aPaqaUNPuWXncGOlivPhjR6nGnLQtQMfCDwW2udB6+9ctv/sKszrg6/5LvtweA
         BV1v0mHW+g5BpCJP+tBnfOXJz0i+O3j4I7lM0/f+cu+Vosg0XiomhNlwpT3mjCBsauOE
         zYfNDMhZhGJh/i4K38einV2AtsSfvhK/jNRk4ImenoqiEiRo1irgy5wp1xeTJKJs32lO
         s8sLkMwbnGuphgQ+SqLmIKUxOr2PHRCODnSVdd2stIUbFnyfDsEVoYjN7dEQM3hRP7TK
         Onf6JWEpYDZ31PmmNspITee31oy535ySnlg2JMsev7ozNwa9lI2fG+mdGKiiuMEizA3c
         E2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AkHj7J7SxrkCHNNUXYijsTUpAYsLcw3KIOqALTlzwM=;
        b=0qiN5T3qFRQgYft85LvX7xUVLoIEJTaxO4cvY3t7KDGOTyxb45xQjc249vFoJW4hLz
         hYm6Bh1KRyF2rXxg2dCVgbLu46oJfkMCI3s21HCPtqhy9znazU/mWNuqdH7PJmVWAsrJ
         WCpwZQpqbFnMrsNhHMuWyM75jOnDY2NVqHsF8E+oHKkad0s7hmBkL015ScaPi+SOs7qx
         NYo2ZFXnO3WP8iahswmn1YYzCBoXkDKrni2W6CwyaKvoEzuWDZNlFdjK2tqSKnw1TUEv
         3xWuSpO+Mf+SQEMAW3r+wySFQM5Qnl1psKap/QsiBeOVEnWYIg6He0XwKURD4bQ3SsCW
         93KQ==
X-Gm-Message-State: AJIora98S2p6DxsOBpLpKGCG+wPzSF3bCl5ZAtzY9PYDv1+bTsY/o5g2
        m7tXUFEJyMvn8PImIFL8nGAG6Q==
X-Google-Smtp-Source: AGRyM1uutdoBMg87A2ujbmkDoo2NwDNywa6hEBeJojvPy4X3ceIhfoBVhkddRdeM/rXU21XbniTlyA==
X-Received: by 2002:a17:906:2245:b0:715:7c81:e39d with SMTP id 5-20020a170906224500b007157c81e39dmr36140248ejr.262.1658320064185;
        Wed, 20 Jul 2022 05:27:44 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o1-20020aa7dd41000000b00436f3107bdasm12129346edw.38.2022.07.20.05.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 05:27:41 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:27:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <Ytf0vDVH7+05f0IS@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfDQ6hpGKXFKfCD@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
>> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
>> +				    struct devlink_info_req *req,
>> +				    struct netlink_ext_ack *extack)
>> +{
>> +	char buf[32];
>> +	int err;
>> +
>> +	mutex_lock(&linecard->lock);
>> +	if (WARN_ON(!linecard->provisioned)) {
>> +		err = 0;
>
>Why not:
>
>err = -EINVAL;
>
>?

Well, a) this should not happen. No need to push error to the user for
this as the rest of the info message is still fine.


>
>> +		goto unlock;
>> +	}
>> +
>> +	sprintf(buf, "%d", linecard->hw_revision);
>> +	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
>> +	if (err)
>> +		goto unlock;
>> +
>> +	sprintf(buf, "%d", linecard->ini_version);
>> +	err = devlink_info_version_running_put(req, "ini.version", buf);
>> +	if (err)
>> +		goto unlock;
>> +
>> +unlock:
>> +	mutex_unlock(&linecard->lock);
>> +	return err;
>> +}
>> +
>>  static int
>>  mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>>  			     u16 hw_revision, u16 ini_version)
>> -- 
>> 2.35.3
>> 
