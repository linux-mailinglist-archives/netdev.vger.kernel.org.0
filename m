Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88382EBF8C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAFOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:25:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8881 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbhAFOZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:25:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff5c8190000>; Wed, 06 Jan 2021 06:24:25 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan 2021 14:24:24
 +0000
References: <1609355503-7981-1-git-send-email-roid@nvidia.com>
 <875z4cwus8.fsf@nvidia.com>
 <405e8cce-e2dd-891a-dc8a-7c8b0c77f4c6@nvidia.com>
 <4a07fbc9-8e1c-ecd6-ee9e-31d1a952ba42@nvidia.com>
 <87y2h6urwe.fsf@nvidia.com>
 <5ed38f17-be13-0c5b-5b2f-1cb58ee77a8c@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2] build: Fix link errors on some systems
In-Reply-To: <5ed38f17-be13-0c5b-5b2f-1cb58ee77a8c@nvidia.com>
Date:   Wed, 6 Jan 2021 15:24:21 +0100
Message-ID: <87turuuoru.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609943065; bh=+QYoQaLgKsR0nGhEgip0pZzXxx0PUBqsyN0OaVrIB7k=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=MxTMKBYdYw6T16r3u7ZGOZsnnePIafLOlR4o3G7xTajouxtWzprG4HcwMvcTXwA/N
         m85qiuGe1vstw2OzDfkHXFP41hIhkmrJR8WE4NWnNeqKPkS0Kt7jFucXVjhKux4WGN
         4gOVhPvZy5CRSqkJxEip+cRZRILcNOiBlriH3nVO+MSfnThaItsEc+N9pYHT4PyWtR
         eH9TK+YbHCi6t5v7sgLdsbnzoQZvlTUeCnPhtZaFSx8rSeFYyj4prXsMVkwfdkbpSl
         o8GJ1Tn9g9kCZeIacX+NavWPxW9POU74WgrLDUGg4AWZHl3Jl7GvdzvxTB0mJPHwQR
         bXs4wo1kTOT3g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> On 2021-01-06 3:16 PM, Petr Machata wrote:
>> Regarding the publishing, the _jw reference can be changed to a call to
>> is_json_context(), which does the same thing. Then _jw can stay private
>> in json_print.c.
>> Exposing an _IS_JSON_CONTEXT / _IS_FP_CONTEXT might be odd on account of
>> the initial underscore, but since it's only used in implementations,
>> maybe it's OK?
>> 
>
> With is_json_context() I cannot check the type passed by the caller.
> i.e. PRINT_JSON, PRINT_FP, PRINT_ANY.

I meant s/_jw/is_json_context()/. Like this:

#define _IS_JSON_CONTEXT(type) \
    ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())

Then _jw can stay private.
