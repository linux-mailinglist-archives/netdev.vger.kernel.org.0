Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07E319898D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 03:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgCaBdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 21:33:24 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:46587 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbgCaBdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 21:33:24 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 02V1WGxM018227;
        Tue, 31 Mar 2020 03:32:21 +0200
Received: from [192.168.1.80] (93-36-196-249.ip61.fastwebnet.it [93.36.196.249])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id DCCFC122910;
        Tue, 31 Mar 2020 03:32:11 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1585618332; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZA+BuNkoFMZJknutDx9BJWIxQCcnJxRo/IgWfooEnog=;
        b=Gmmobygek/JzH4NA5PhWAxPvnT6YH1naati8gdJlEiM9zdy+rv7YVp28nAOthvhwQkeAQv
        6x9zhC7058T1IyBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1585618332; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZA+BuNkoFMZJknutDx9BJWIxQCcnJxRo/IgWfooEnog=;
        b=RFNKoRW/Vx7Q6+sszu/W2zY044+ZJ29E/SSpS4ZW6BYb2bBv3hOJq20022tJiJhvjEWkJO
        o7x99wRN4HnwerNR3DeU0Zg0iYA4Dn4hJqA1akiDLjxLvaUB4FsNvPBkTU+kNPKdSlMIWz
        uaQg+PEbBaZusr/dvNu8H8wh2szIMdNyHM8prN7LuG3Xp5Z27LIDgfqWk53PfMBE+HBDGi
        YFwYLJpKZ+2qdf2sz6OF8drqaPYsaX5ls3sYt0teLp7ylFhP8TlGjgok03c4VuQydclIWc
        31V/7JTfynGdUEvhLfEm9ppDEuyG0flQD+RN4ggKvp8LGT/vee8GNqkYPmF+3g==
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, bpf@vger.kernel.org,
        paolo.lungaroni@cnit.it, ahmed.abdelsalam@gssi.it
References: <20200319183641.29608-1-andrea.mayer@uniroma2.it>
 <20200325.193016.1654692564933635575.davem@davemloft.net>
 <20200331012348.e0b2373bd4a96fecc77686b6@uniroma2.it>
 <20200330.174944.1829532392145435132.davem@davemloft.net>
From:   Stefano Salsano <stefano.salsano@uniroma2.it>
Message-ID: <1a9409cd-0e2b-577b-f522-4149beca9d7c@uniroma2.it>
Date:   Tue, 31 Mar 2020 03:32:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330.174944.1829532392145435132.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 2020-03-31 02:49, David Miller ha scritto:
> From: Stefano Salsano <stefano.salsano@uniroma2.it>
> Date: Tue, 31 Mar 2020 01:23:48 +0200
> 
>> Of course a new application (e.g. iproute2, pyroute) using a new optional
>> parameter will not work on older kernels, but simply because the new parameter
>> is not supported. It will not work even without our proposed patch.
>>
>> On the other hand, we think that the solution in the patch is more backward
>> compatible. Without the patch, if we define new attributes, old applications
>> (e.g. iproute2 scripts) will not work on newer kernels, while with the optional
>> attributes approach proposed in the patch they will work with no issues !
> 
> Translation: You want to add backwards compatibility problems because
> otherwise you'll have to add backwards compatibility problems.

no this is not the correct translation :-) we do not want to add any 
backward compatility problem

we need to add a number of new parameters, if we keep the current 
approach these parameters will be mandatory and we will have backward 
compatibility problems: old applications will not work with new kernels

if we are allowed to add optional parameters, old applications and new 
applications will be able to work with old kernels and new kernels in 
any combination

> Sorry, I'm still not convinced.
> 
> You must find another way to achieve your objective.


-- 
*******************************************************************
Stefano Salsano
Professore Associato
Dipartimento Ingegneria Elettronica
Universita' di Roma Tor Vergata
Viale Politecnico, 1 - 00133 Roma - ITALY

http://netgroup.uniroma2.it/Stefano_Salsano/

E-mail  : stefano.salsano@uniroma2.it
Cell.   : +39 320 4307310
Office  : (Tel.) +39 06 72597770 (Fax.) +39 06 72597435
*******************************************************************

